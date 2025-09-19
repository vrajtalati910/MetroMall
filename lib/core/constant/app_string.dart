class AppStrings {
  static const storageUrl = '';
  static const tokenKey = 'token';
  static const userPrefKey = 'user';
  static const printPrefKey = 'print';

  static const baseUrl = 'https://tailormate-api-production.up.railway.app/api';

  // AUTH
  static const login = '$baseUrl/v1/login';

  //measurements
  static const measurementsList = '$baseUrl/v1/measurements/';
  static const createMeasurement = '$baseUrl/v1/measurements/create';
  static updateMeasurement(int id) => '$baseUrl/v1/measurements/update/$id';

  //items
  static const itemsList = '$baseUrl/v1/items/';
  static itemsDetail(int id) => '$baseUrl/v1/items/details/$id';
  static const createItem = '$baseUrl/v1/items/create';
  static updateitems(int id) => '$baseUrl/v1/items/update/$id';

  //customer
  static const customersList = '$baseUrl/v1/customers/';
  static customersDetail(int id) => '$baseUrl/v1/customers/details/$id';
  static const createCustomers = '$baseUrl/v1/customers/create';
  static updateCustomers(int id) => '$baseUrl/v1/customers/update/$id';
  static customerItemDetail(int id) => '$baseUrl/v1/customers/items-details/$id';
  static customerItemAdd(int id) => '$baseUrl/v1/customers/add-item/$id';
  static customerItemUpdate(int id) => '$baseUrl/v1/customers/update-item/$id';
}
