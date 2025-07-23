import 'package:flutter_template/app/data/models/site_info_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service for managing coffee site information using Hive storage.
class SiteService {
  /// Initializes the site service and opens the Hive box.
  Future<SiteService> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SiteInfoAdapter());

    await Hive.openBox<SiteInfo>('site_info');

    return this;
  }

  /// The Hive box for site information.
  Box<SiteInfo> get _siteBox => Hive.box<SiteInfo>('site_info');

  /// Adds a new site. Throws if limit reached or duplicate name.
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

  /// Returns all sites, optionally limited by [limit].
  List<SiteInfo> getAllSites({int? limit}) {
    final sites = _siteBox.values.toList();
    sites.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first
    if (limit != null) {
      return sites.take(limit).toList();
    }
    return sites;
  }

  /// Updates an existing site. Throws if duplicate name.
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

  /// Deletes a site by its [id].
  Future<void> deleteSite(String id) async {
    await _siteBox.delete(id);
  }

  /// Returns a site by its [id], or null if not found.
  SiteInfo? getSiteById(String id) => _siteBox.get(id);
}
