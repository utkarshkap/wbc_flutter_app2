import 'dart:convert';

Dashboard dashboardFromJson(String str) => Dashboard.fromJson(json.decode(str));

String dashboardToJson(Dashboard data) => json.encode(data.toJson());

class Dashboard {
  Dashboard({
    required this.code,
    required this.message,
    required this.data,
  });

  final int code;
  final String message;
  final Data data;

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };

  @override
  String toString() {
    return 'Dashboard{code: $code, message: $message, data: $data}';
  }
}

class Data {
  Data(
      {required this.stockPortfolio,
      required this.stockInvestment,
      required this.stockGain,
      required this.stockBalance,
      required this.mfTotalBalanceUnit,
      required this.mfTotalPurchaseAmount,
      required this.mfTotalRedeemAmount,
      required this.mfTotalAmount,
      required this.mfTotalScheme,
      required this.mutualFunds,
      required this.goldPoint,
      required this.redeemable,
      required this.nonRedeemable,
      required this.onTheSpot,
      required this.mgainInv,
      required this.fastTrack,
      required this.earning,
      required this.history,
      required this.addContacts,
      required this.totalcountofaddedcontact,
      required this.maxContactPermittedPerMonth,
      required this.availableContacts,
      required this.wbcProgress,
      required this.wbcThisMonth,
      required this.contactBase,
      required this.offers,
      required this.inActive,
      required this.memberlist});

  final double stockPortfolio;
  final double stockInvestment;
  final double stockGain;
  final double stockBalance;
  final double mfTotalBalanceUnit;
  final double mfTotalPurchaseAmount;
  final double mfTotalRedeemAmount;
  final double mfTotalAmount;
  final int mfTotalScheme;
  final double mutualFunds;
  final int goldPoint;
  final int redeemable;
  final int nonRedeemable;
  final int onTheSpot;
  final double mgainInv;
  final double fastTrack;
  final List<Earning> earning;
  final List<History> history;
  final int addContacts;
  final int totalcountofaddedcontact;
  final int maxContactPermittedPerMonth;
  final int availableContacts;
  final int wbcProgress;
  final int wbcThisMonth;
  final List<ContactBase> contactBase;
  final List<Offer> offers;
  final List<InActive> inActive;
  final List<Memberlist> memberlist;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        stockPortfolio: json["stock_Portfolio"].toDouble(),
        stockInvestment: json["stock_Investment"].toDouble(),
        stockGain: json["stock_Gain"].toDouble(),
        stockBalance: json["stock_Balance"].toDouble(),
        mfTotalBalanceUnit: json["mf_totalBalanceUnit"].toDouble(),
        mfTotalPurchaseAmount: json["mf_totalPurchaseAmount"].toDouble(),
        mfTotalRedeemAmount: json["mf_totalRedeemAmount"].toDouble(),
        mfTotalAmount: json["mf_totalAmount"].toDouble(),
        mfTotalScheme: json["mf_totalScheme"],
        mutualFunds: json["mutualFunds"].toDouble(),
        goldPoint: json["goldPoint"],
        redeemable: json["redeemable"],
        nonRedeemable: json["nonRedeemable"],
        onTheSpot: json["onTheSpot"],
        mgainInv: json["mgain_inv"].toDouble(),
        fastTrack: json["fastTrack"].toDouble(),
        earning: json["earning"] == null
            ? []
            : List<Earning>.from(
                json["earning"].map((x) => Earning.fromJson(x))),
        history: json["history"] == null
            ? []
            : List<History>.from(
                json["history"].map((x) => History.fromJson(x))),
        totalcountofaddedcontact: json["totalcountofaddedcontact"],
        maxContactPermittedPerMonth: json["maxContactPermittedPerMonth"],
        availableContacts: json["availableContacts"],
        addContacts: json["addContacts"],
        wbcProgress: json["wbcProgress"],
        wbcThisMonth: json["wbcThisMonth"],
        contactBase: json["contactBase"] == null
            ? []
            : List<ContactBase>.from(
                json["contactBase"].map((x) => ContactBase.fromJson(x))),
        offers: json["offers"] == null
            ? []
            : List<Offer>.from(json["offers"].map((x) => Offer.fromJson(x))),
        inActive: json["inActive"] == null
            ? []
            : List<InActive>.from(
                json["inActive"].map((x) => InActive.fromJson(x))),
        memberlist: json["memberlist"] == null
            ? []
            : List<Memberlist>.from(
                json["memberlist"].map((x) => Memberlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "stock_Portfolio": stockPortfolio,
        "stock_Investment": stockInvestment,
        "stock_Gain": stockGain,
        "stock_Balance": stockBalance,
        "mf_totalBalanceUnit": mfTotalBalanceUnit,
        "mf_totalPurchaseAmount": mfTotalPurchaseAmount,
        "mf_totalRedeemAmount": mfTotalRedeemAmount,
        "mf_totalAmount": mfTotalAmount,
        "mf_totalScheme": mfTotalScheme,
        "mutualFunds": mutualFunds,
        "goldPoint": goldPoint,
        "redeemable": redeemable,
        "nonRedeemable": nonRedeemable,
        "onTheSpot": onTheSpot,
        "mgain_inv": mgainInv,
        "fastTrack": fastTrack,
        "earning": List<dynamic>.from(earning.map((x) => x.toJson())),
        "history": List<dynamic>.from(history.map((x) => x.toJson())),
        "totalcountofaddedcontact": totalcountofaddedcontact,
        "maxContactPermittedPerMonth": maxContactPermittedPerMonth,
        "availableContacts": availableContacts,
        "addContacts": addContacts,
        "wbcProgress": wbcProgress,
        "wbcThisMonth": wbcThisMonth,
        "contactBase": List<dynamic>.from(contactBase.map((x) => x.toJson())),
        "offers": List<dynamic>.from(offers.map((x) => x.toJson())),
        "inActive": List<dynamic>.from(inActive.map((x) => x.toJson())),
        "memberlist": List<dynamic>.from(memberlist.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'Data{stock_Portfolio: $stockPortfolio, stock_Investment: $stockInvestment, stock_Gain: $stockGain, mf_totalBalanceUnit: $mfTotalBalanceUnit, mf_totalPurchaseAmount: $mfTotalPurchaseAmount, mf_totalRedeemAmount: $mfTotalRedeemAmount, mf_totalAmount: $mfTotalAmount, mf_totalScheme: $mfTotalScheme, mutualFunds: $mutualFunds, goldPoint: $goldPoint, redeemable: $redeemable, nonRedeemable: $nonRedeemable, onTheSpot: $onTheSpot,mgain_inv: $mgainInv, fastTrack: $fastTrack, earning: $earning, history: $history, addContacts: $addContacts, totalcountofaddedcontact: $totalcountofaddedcontact, maxContactPermittedPerMonth: $maxContactPermittedPerMonth, availableContacts: $availableContacts, wbcProgress: $wbcProgress, wbcThisMonth: $wbcThisMonth, contactBase: $contactBase, offers: $offers, inActive: $inActive, memberlist: $memberlist}';
  }
}

class ContactBase {
  ContactBase({
    required this.type,
    required this.count,
    required this.referralList,
  });

  final String type;
  final int count;
  final List<ReferralList> referralList;

  factory ContactBase.fromJson(Map<String, dynamic> json) => ContactBase(
        type: json["type"],
        count: json["count"],
        referralList: json["referralList"] == null
            ? []
            : List<ReferralList>.from(
                json["referralList"].map((x) => ReferralList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "count": count,
        "referralList": List<dynamic>.from(referralList.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'ContactBase{type: $type, count: $count, referralList: $referralList}';
  }
}

class ReferralList {
  final String refName;
  final String refMobile;
  final DateTime refDate;
  final bool userexist;

  ReferralList({
    required this.refName,
    required this.refMobile,
    required this.refDate,
    required this.userexist,
  });

  factory ReferralList.fromJson(Map<String, dynamic> json) => ReferralList(
        refName: json["ref_name"],
        refMobile: json["ref_mobile"],
        refDate: DateTime.parse(json["ref_date"]),
        userexist: json["userexist"],
      );

  Map<String, dynamic> toJson() => {
        "ref_name": refName,
        "ref_mobile": refMobile,
        "ref_date": refDate.toIso8601String(),
        "userexist": userexist,
      };
  @override
  String toString() {
    return 'ReferralList{ref_name: $refName, ref_mobile: $refMobile, ref_date: $refDate, userexist: $userexist}';
  }
}

class InActive {
  InActive({
    required this.type,
    required this.count,
    required this.userList,
  });

  final String type;
  final int count;
  final List<UserList> userList;

  factory InActive.fromJson(Map<String, dynamic> json) => InActive(
        type: json["type"],
        count: json["count"],
        userList: json["userList"] == null
            ? []
            : List<UserList>.from(
                json["userList"].map((x) => UserList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "count": count,
        "userList": List<dynamic>.from(userList.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return 'InActive{type: $type, count: $count, userList: $userList}';
  }
}

class UserList {
  final String refName;
  final String refMobile;
  final DateTime refDate;
  final bool userexist;

  UserList({
    required this.refName,
    required this.refMobile,
    required this.refDate,
    required this.userexist,
  });

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
        refName: json["ref_name"],
        refMobile: json["ref_mobile"],
        refDate: DateTime.parse(json["ref_date"]),
        userexist: json["userexist"],
      );

  Map<String, dynamic> toJson() => {
        "ref_name": refName,
        "ref_mobile": refMobile,
        "ref_date": refDate.toIso8601String(),
        "userexist": userexist,
      };
  @override
  String toString() {
    return 'UserList{ref_name: $refName, ref_mobile: $refMobile, ref_date: $refDate, userexist: $userexist}';
  }
}

class History {
  History({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.credit,
    required this.debit,
    required this.description,
    required this.date,
    required this.status,
    required this.goldPointType,
  });

  final int id;
  final String name;
  final String imgUrl;
  final int? credit;
  final int? debit;
  final String description;
  final String date;
  final String status;
  final String goldPointType;

  factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"],
        name: json["name"],
        imgUrl: json["imgUrl"],
        credit: json["credit"],
        debit: json["debit"],
        description: json["description"],
        date: json["date"],
        status: json["status"],
        goldPointType: json["goldPointType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imgUrl": imgUrl,
        "credit": credit,
        "debit": debit,
        "description": description,
        "date": date,
        "status": status,
        "goldPointType": goldPointType,
      };

  @override
  String toString() {
    return 'History{id: $id, name: $name, imgUrl: $imgUrl, credit: $credit, debit: $debit, description: $description,  date: $date, status: $status, goldPointType: $goldPointType}';
  }
}

class Earning {
  Earning({
    required this.ftId,
    required this.timestamp,
    required this.credit,
    required this.debit,
    required this.userid,
    required this.invetmentType,
    required this.invetmentSubType,
    required this.narration,
  });

  final int ftId;
  final String timestamp;
  final double credit;
  final double debit;
  final int userid;
  final String invetmentType;
  final String invetmentSubType;
  final String narration;

  factory Earning.fromJson(Map<String, dynamic> json) => Earning(
        ftId: json["ft_id"],
        timestamp: json["timestamp"],
        credit: json["credit"],
        debit: json["debit"],
        userid: json["userid"],
        invetmentType: json["invetmentType"],
        invetmentSubType: json["invetmentSubType"],
        narration: json["narration"],
      );

  Map<String, dynamic> toJson() => {
        "ft_id": ftId,
        "timestamp": timestamp,
        "credit": credit,
        "debit": debit,
        "userid": userid,
        "invetmentType": invetmentType,
        "invetmentSubType": invetmentSubType,
        "narration": narration,
      };

  @override
  String toString() {
    return 'History{ft_id: $ftId, timestamp: $timestamp,credit:$credit, debit:$debit,userid:$userid, invetmentType:$invetmentType,invetmentSubType:$invetmentSubType,narration:$narration}';
  }
}

class Offer {
  Offer({
    required this.id,
    required this.title,
    required this.imgUrl,
  });

  int id;
  String title;
  String imgUrl;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        title: json["title"],
        imgUrl: json["imgUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "imgUrl": imgUrl,
      };

  @override
  String toString() {
    return 'Offer{id: $id, title: $title, imgUrl: $imgUrl}';
  }
}

class Memberlist {
  Memberlist({
    required this.id,
    required this.name,
    required this.mobileno,
    required this.relation,
    required this.familyid,
    required this.relativeUserId,
  });

  final int id;
  final String name;
  final String mobileno;
  final String relation;
  final int familyid;
  final int relativeUserId;

  factory Memberlist.fromJson(Map<String, dynamic> json) => Memberlist(
        id: json["id"],
        name: json["name"],
        mobileno: json["mobileno"],
        relation: json["relation"],
        familyid: json["familyid"],
        relativeUserId: json["relativeUserId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobileno": mobileno,
        "relation": relation,
        "familyid": familyid,
        "relativeUserId": relativeUserId,
      };

  @override
  String toString() {
    return 'Memberlist{id: $id, name: $name, mobileno: $mobileno, relation: $relation, familyid: $familyid, relativeUserId: $relativeUserId}';
  }
}
