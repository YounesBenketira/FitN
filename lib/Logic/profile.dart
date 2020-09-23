class Profile {
  final String firstName;
  final String lastName;
  final int exercisesDone;
  final String profileID;
  final List<dynamic> friends;
  final List inbox;

  Profile(
      {this.profileID,
      this.firstName,
      this.lastName,
      this.exercisesDone,
      this.friends,
      this.inbox});

  @override
  String toString() {
    // TODO: implement toString
    return "$profileID $firstName $lastName";
  }
}
