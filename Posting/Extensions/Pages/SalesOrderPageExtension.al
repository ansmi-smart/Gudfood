pageextension 50031 SalesOrderPageExtension extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Cust. Post. Description ANSMI"; Rec."Cust. Post. Description ANSMI")
            {
                ApplicationArea = All;
                ShowMandatory = true;
                Editable = false;
            }
        }

    }

    actions
    {
        addafter("&Order Confirmation")
        {
            action("Add description ANSMI")
            {
                ApplicationArea = All;
                Caption = 'Set Description ANSMI Wizard';
                Image = Setup;
                RunObject = Page "Set Description ANSMI Wizard";
                RunPageLink = "No." = field("No.");
            }
        }
        addafter("Pick Instruction")
        {
            action("Report ANSMI")
            {
                ApplicationArea = All;
                Caption = 'Report ANSMI';
                Image = Print;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Report.Run(50071, true, true, Rec);
                end;
            }
        }
    }
}