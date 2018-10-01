import 'package:HaltonBusAPI/HaltonBusAPI.dart';

class RouteFilter {
  final String name;
  final String school;
  final int route;

  const RouteFilter(this.name, {this.school, this.route});

  bool doesInclude(Delay delay) {
    final containsSchool = delay.schools.contains(school.toUpperCase());
    final sameRoute = delay.route == route;

    if(containsSchool && sameRoute) return true;
    return false;
  }

  RouteFilter.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        school = json['school'],
        route = json['route'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'school': school,
        'route': route
      };
}

List<Delay> filter(List<RouteFilter> filters, List<Delay> unfilteredList) {
  return unfilteredList
      .where((delay) => filters.where((filter) => filter.doesInclude(delay)).length > 0)
      .toList();
}