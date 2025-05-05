import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';

import 'colors.dart';

class AppIcons {
  AppIcons._();

  // Accounts
  static IconData sales = LineIcons.shoppingBag;
  static IconData purchase = LineIcons.shoppingCart;
  static IconData products = LineIcons.box;
  static IconData customers = LineIcons.userFriends;
  static IconData banking = LineIcons.piggyBank;


  //Main Icons
  static IconData home = LineIcons.home;
  static IconData store = FontAwesomeIcons.store;
  static IconData category = LineIcons.box;
  // static IconData favorite = LineIcons.heart;
  static IconData favorite = FontAwesomeIcons.star; //heart
  static IconData user = LineIcons.user;
  static IconData search = Icons.search;

  // cart
  static IconData bottomNavigationCart = LineIcons.shoppingBag;
  static IconData counterCart = FontAwesomeIcons.cartPlus;
  static IconData cartEmpty = FontAwesomeIcons.cartPlus;
  static IconData cartFull = FontAwesomeIcons.cartShopping;
  static IconData cartVariation = FontAwesomeIcons.plus;

  //Menu Icons
  // static IconData location = LineIcons.mapMarker;
  static IconData location = FontAwesomeIcons.locationDot;
  // static IconData order = LineIcons.shoppingBasket;
  static IconData order = FontAwesomeIcons.receipt;
  // static IconData coupons = LineIcons.tag;
  static IconData coupons = FontAwesomeIcons.gift;
  // static IconData recentlyView = LineIcons.history;
  static IconData recentlyView = FontAwesomeIcons.bookmark;
  // static IconData logout = LineIcons.firstOrder;
  static IconData logout = FontAwesomeIcons.rightFromBracket;

  // Form Icons
  static IconData edit = FontAwesomeIcons.pen;
  static IconData whatsapp = FontAwesomeIcons.whatsapp;
  static IconData email = FontAwesomeIcons.paperPlane;
  static IconData phone = FontAwesomeIcons.headset;
  static IconData call = FontAwesomeIcons.phone;
  static Icon password = const Icon(LineIcons.searchLocation);
  static Icon address1 = const Icon(LineIcons.searchLocation);
  static Icon address2 = const Icon(LineIcons.searchLocation);
  static Icon city = const Icon(LineIcons.searchLocation);
  static Icon pincode = const Icon(LineIcons.searchLocation);
  static Icon state = const Icon(LineIcons.searchLocation);
  static Icon country = const Icon(LineIcons.searchLocation);

  //Orders Icons
  static IconData orderDetails = LineIcons.alternateList;

  //Policies icons
  static IconData privacyPolicy = FontAwesomeIcons.shieldHalved;
  static IconData shippingPolicy = FontAwesomeIcons.truck;
  static IconData termsAndConditions = FontAwesomeIcons.fileContract;
  static IconData returnPolicy = FontAwesomeIcons.rotateLeft;

  //Follow us icons
  static IconData share = Icons.share;
  static IconData share2 = FontAwesomeIcons.share;
  static IconData facebook = FontAwesomeIcons.facebook;
  static IconData instagram = FontAwesomeIcons.instagram;
  static IconData telegram = FontAwesomeIcons.telegram;
  static IconData twitter = FontAwesomeIcons.twitter;
  static IconData youtube = FontAwesomeIcons.youtube;

  //Play store feedback link
  static IconData rateUs = FontAwesomeIcons.googlePlay;

  //Products icons
  static IconData starRating = LineIcons.starAlt;

  //General Icons
  static IconData truck = FontAwesomeIcons.truckFast;

}