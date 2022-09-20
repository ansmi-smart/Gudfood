pageextension 50032 SalesInvoicePageExtension extends "Sales Invoice"
{
    layout
    {
        addlast(General)
        {
            field("Cust. Post. Description ANSMI"; Rec."Cust. Post. Description ANSMI")
            {
                ApplicationArea = All;
            }
        }
    }
}
