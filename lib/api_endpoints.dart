
import 'package:flutter_escaperank_web/configuration.dart';

class Api {
  static var baseURL = Config.BASE_URL;
  static const apiKey = "EscapeRank1212";
  static const searchEscapeRoom = '/api/escaperooms';
  static const getTopics = '/api/escaperooms/topics';
  static const getFeatured = '/api/escaperooms/featured';
  static const makeFav = '/api/escaperooms/mark-as-favorite';
  static const makeUnfav = '/api/escaperooms/unmark-as-favorite';
  static const markCompleted = '/api/escaperooms/mark-as-completed';
  static const markUncompleted = '/api/escaperooms/unmark-as-completed';
  static const registerUser = '/api/escapists/register';
  static const socialLogin = '/api/escapists/social-login';
  static const updateUser = '/api/escapists/update-profile';
  static const loginUser = '/api/users/sessions';
  static const getUser = '/api/users/current';
  static const changePassword = '/api/users/update-password';
  static const checkStatus = '/api/status';
  static const validationPhone = '/api/two_factor/validation';
  static const verificationCode = '/api/two_factor/verification';
  static const teams = '/api/teams';
  static const getPhones = '/api/escapists/phones';
  static const getCurrentTeams = '/api/teams/current-user';
  static const getUserBookings = '/api/reservations/current-user';
  static const booking = '/api/reservations';
  static const getSummary = '/api/payments/summary';
  static const paymentsCharge = '/api/payments/charge';
  static const getNotifications = '/api/notifications';
  static const readNotifications = '/api/notifications';
  static const rankingEscapists = '/api/escapists/ranking';
  static const rankingTeams = '/api/teams/ranking';
  static const reviewBooking = '/api/reservations';
  static const getEscapistById  ='/api/escapists';
  static const deleteEscapistAccount = '/api/users/current';
}

/*
class Turitop {
  static const baseURL = "app.turitop.com";
  static const shortId = "E691";
  static const secretKey = "bab98E7AuomtuQXVQFgqdqdbeZhIAtau";
  static const grantAuthorization = '/v1/authorization/grant';
  static const getProductInfo = '/v1/product/wpinfo';
  static const getEvents = '/v1/product/tour/getavailable';
  static const getClientForm = '/v1/product/getclientform';
  static const getBooking = '/v1/booking/getbooking';
  static const getTickets = '/v1/tickets/get';
  static const getTicketsPrices = '/v1/tickets/getprices';
  static const insertBooking = '/v1/booking/tour/insert';
  static const editBooking = '/v1/booking/tour/edit';
  static const codeClosedEventFull = '1000';
  static const codeClosedAutoClosed = '2000';
  static const codeClosedLate = '4000';

}
 */

class Responses {
  static const RESPONSE_OK = 200;
  static const RESPONSE_OK_NO_CONTENT = 201;
  static const RESPONSE_EDIT_OK_NO_CONTENT = 204;
  static const RESPONSE_NOT_AUTHORIZED = 401;
  static const RESPONSE_UNPROCESSABLE_ENTITY = 422;
  static const RESPONSE_NOT_EXIST = 412;
  static const TOKEN_NOT_VALID = 406;
}

class BookingsLayerApi{
  static const getCalendarAvailability = '/api/bookings_layer/calendar_availability';
  static const getEventTickets = '/api/bookings_layer/event_tickets';
}