class ReferralSources {
  final int totalReferrals;
  final int androidApp;
  final int organicGoogle;
  final int direct;
  final int other;

  ReferralSources({
    required this.totalReferrals,
    required this.androidApp,
    required this.organicGoogle,
    required this.direct,
    required this.other,
  });

  // Add empty factory constructor for initialization
  factory ReferralSources.empty() => ReferralSources(
    totalReferrals: 0,
    androidApp: 0,
    organicGoogle: 0,
    direct: 0,
    other: 0,
  );
}

class OrganicSources {
  final int totalOrganic;
  final int facebook;
  final int instagram;
  final int google;

  OrganicSources({
    required this.totalOrganic,
    required this.facebook,
    required this.instagram,
    required this.google,
  });

  factory OrganicSources.empty() => OrganicSources(
    totalOrganic: 0,
    facebook: 0,
    instagram: 0,
    google: 0,
  );
}

class AdSources {
  final int totalAds;
  final int facebook;
  final int instagram;
  final int google;

  AdSources({
    required this.totalAds,
    required this.facebook,
    required this.instagram,
    required this.google,
  });

  factory AdSources.empty() => AdSources(
    totalAds: 0,
    facebook: 0,
    instagram: 0,
    google: 0,
  );
}

class AnalyticsModel {
  final double totalRevenue;
  final double completedRevenue;
  final double rtoRevenue;
  final int totalOrders;
  final int completedOrders;
  final int rtoOrders;
  final double cogs;
  final double shippingCost;
  final double facebookAds;
  final double googleAds;
  final double rent;
  final double travel;
  final double profit;
  final double aov;
  final double cogsPerOrder;
  final double shippingPerOrder;
  final double adsCompleted;
  final double adsTotal;
  final int returningCustomers;
  final double rtoReturningCustomerRate;
  final int couponUsed;
  final ReferralSources referralSources;
  final OrganicSources organicSources;
  final AdSources adSources;

  AnalyticsModel({
    required this.totalRevenue,
    required this.completedRevenue,
    required this.rtoRevenue,
    required this.totalOrders,
    required this.completedOrders,
    required this.rtoOrders,
    required this.cogs,
    required this.shippingCost,
    required this.facebookAds,
    required this.googleAds,
    required this.rent,
    required this.travel,
    required this.profit,
    required this.aov,
    required this.cogsPerOrder,
    required this.shippingPerOrder,
    required this.adsCompleted,
    required this.adsTotal,
    required this.returningCustomers,
    required this.rtoReturningCustomerRate,
    required this.couponUsed,
    required this.referralSources,
    required this.organicSources,
    required this.adSources,
  });

  // Add empty factory constructor
  factory AnalyticsModel.empty() => AnalyticsModel(
    totalRevenue: 0,
    completedRevenue: 0,
    rtoRevenue: 0,
    totalOrders: 0,
    completedOrders: 0,
    rtoOrders: 0,
    cogs: 0,
    shippingCost: 0,
    facebookAds: 0,
    googleAds: 0,
    rent: 0,
    travel: 0,
    profit: 0,
    aov: 0,
    cogsPerOrder: 0,
    shippingPerOrder: 0,
    adsCompleted: 0,
    adsTotal: 0,
    returningCustomers: 0,
    rtoReturningCustomerRate: 0,
    couponUsed: 0,
    referralSources: ReferralSources.empty(),
    organicSources: OrganicSources.empty(),
    adSources: AdSources.empty(),
  );
}