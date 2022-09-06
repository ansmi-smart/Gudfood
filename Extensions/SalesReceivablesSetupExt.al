tableextension 50011 SalesReceivablesSetupExt extends "Sales & Receivables Setup"
{
    fields
    {
        field(50001; "Gudfood Order Nos."; Code[20])
        {
            Caption = 'Gudfood Item Nos.';
            TableRelation = "No. Series";
        }
        field(50002; "Gudfood Item Nos."; Code[20])
        {
            Caption = 'Gudfood Item Nos.';
            TableRelation = "No. Series";
        }
        field(50003; "Posted Gudfood Item Nos."; Code[20])
        {
            Caption = 'Gudfood Item Nos.';
            TableRelation = "No. Series";
        }

    }
}
