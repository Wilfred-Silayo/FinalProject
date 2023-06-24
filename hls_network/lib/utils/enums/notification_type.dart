enum NotificationType {
  like('like'),
  reply('reply'),
  follow('follow');

  final String type;
  const NotificationType(this.type);
}

extension ConvertPost on String {
  NotificationType toNotificationTypeEnum() {
    switch (this) {
      case 'follow':
        return NotificationType.follow;
      case 'reply':
        return NotificationType.reply;
      default:
        return NotificationType.like;
    }
  }
}
