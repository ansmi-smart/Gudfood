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

            field("Posted Gudfood Item Nos."; Rec."Posted Gudfood Item Nos.")
            {
                Caption = 'Posted Gudfood Item Nos.';
                ApplicationArea = All;
            }
        }
        addlast(Templates)
        {
            field("ANSMI Excel Report"; Rec."ANSMI Excel Report")
            {
                Caption = 'ANSMI Excel Report';
                ApplicationArea = All;
            }
        }
    }
}
