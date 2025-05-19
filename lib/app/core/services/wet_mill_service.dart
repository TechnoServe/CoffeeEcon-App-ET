import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SiteService {
  Future<SiteService> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SiteInfoAdapter());

    await Hive.openBox<SiteInfo>('site_info');

    return this;
  }

  Box<SiteInfo> get _siteBox => Hive.box<SiteInfo>('site_info');

  Future<bool> addSite(SiteInfo site) async {
    if (_siteBox.length >= 10) {
      throw Exception('LIMIT_REACHED');
    }

    final bool exists = _siteBox.values.any((s) => s.siteName == site.siteName);
    if (exists) {
      throw Exception('DUPLICATE_NAME');
    }

    try {
      await _siteBox.put(site.id, site);
      return true;
    } catch (e) {
      return false;
    }
  }

  List<SiteInfo> getAllSites({int? limit}) {
    final sites = _siteBox.values.toList();
    sites.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first
    if (limit != null) {
      return sites.take(limit).toList();
    }
    return sites;
  }

  Future<bool> updateSite(SiteInfo site) async {
    final original = _siteBox.get(site.id);

    // Skip duplicate check if siteName didn't change
    if (original != null && original.siteName != site.siteName) {
      final bool exists = _siteBox.values.any(
        (s) => s.siteName == site.siteName && s.id != site.id,
      );
      if (exists) {
        throw Exception('DUPLICATE_NAME');
      }
    }

    try {
      await _siteBox.put(site.id, site);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteSite(String id) async {
    await _siteBox.delete(id);
  }

  SiteInfo? getSiteById(String id) => _siteBox.get(id);
}
