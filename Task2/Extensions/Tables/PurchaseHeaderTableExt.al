tableextension 50051 PurchaseHeaderTableExt extends "Purchase Header"
{
    fields
    {
        field(50000; "Lines Counter ANSMI"; Integer)
        {
            Caption = 'Lines counter ANSMI';
            FieldClass = FlowField;
            CalcFormula = count("Purchase Line" where("Document No." = FIELD("No.")));
        }
    }
}