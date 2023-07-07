enum ConferenceType {
  audio('audio'),
  video('video');

  final String type;
  const ConferenceType(this.type);
}

extension ConvertConference on String {
  ConferenceType toConferenceTypeEnum() {
    switch (this) {
      case 'audio':
        return ConferenceType.audio;
      case 'video':
        return ConferenceType.video;
      default:
        return ConferenceType.audio;
    }
  }
}
