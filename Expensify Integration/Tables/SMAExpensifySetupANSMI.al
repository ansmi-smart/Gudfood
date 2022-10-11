table 50066 "SMA Expensify Setup ANSMI"
{
    Caption = 'SMA Expensify Setup ANSMI';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "partnerUserID "; Text[100])
        {
            Caption = 'partnerUserID ';
            DataClassification = ToBeClassified;
        }
        field(2; "partnerUserSecret "; Text[250])
        {
            Caption = 'partnerUserSecret ';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "partnerUserID ")
        {
            Clustered = true;
        }
    }
}
