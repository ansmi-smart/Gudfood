tableextension 50011 SalesReceivablesSetupExt extends "Sales & Receivables Setup"
{
    fields
    {
        field(70001; "Gudfood Order Nos."; Code[20])
        {
            Caption = 'Gudfood Item Nos.';
            TableRelation = "No. Series";
        }
        field(70002; "Gudfood Item Nos."; Code[20])
        {
            Caption = 'Gudfood Item Nos.';
            TableRelation = "No. Series";
        }

    }
}
pageextension 50011 SalesReceivablesSetupPageExt extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Customer Nos.")
        {
            field("Gudfood Order Nos."; Rec."Gudfood Order Nos.")
            {
                Caption = 'Gudfood Order Nos.';
                ApplicationArea = All;
            }

            field("Gudfood Item Nos."; Rec."Gudfood Item Nos.")
            {
                Caption = 'Gudfood Item Nos.';
                ApplicationArea = All;
            }
        }
    }
}
