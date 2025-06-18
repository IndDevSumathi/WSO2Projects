type BillPaymentRequest record {|
    string uid;
    string acc_num;
    string provider;
|};

type BillPaymentResponse record {|
    string status;
    int billRefNo;
|};

type BillDetails record {|
    int dueAmount;
    string duePending;
|};

type MPesaAccount record {|
    int balance;
|};