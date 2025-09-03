class HotspotUser {
  final String id;
  final String name;
  final String? password;
  final String? profile;
  final String? uptime;
  final String? comment;
  final bool disabled;

  HotspotUser({
    required this.id,
    required this.name,
    this.password,
    this.profile,
    this.uptime,
    this.comment,
    this.disabled = false,
  });

  factory HotspotUser.fromMap(Map<String, String> d) {
    return HotspotUser(
      id: d['.id'] ?? '',
      name: d['name'] ?? '',
      password: d['password'],
      profile: d['profile'],
      uptime: d['uptime'],
      comment: d['comment'],
      disabled: (d['disabled'] ?? 'false') == 'true',
    );
  }
}
