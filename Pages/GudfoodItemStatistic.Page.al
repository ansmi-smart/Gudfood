page 50025 "Gudfood Item Statistics"
{
    Caption = 'Gudfood Item Statistics';
    PageType = CardPart;
    SourceTable = "Gudfood Item";

    layout
    {
        area(Content)
        {
            field("Code"; Code)
            {
                ApplicationArea = All;
                Caption = 'Item code';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field("Amount of usage"; Quantity)
            {
                ApplicationArea = All;
                Caption = 'Amount of usage';

                trigger OnDrillDown()
                begin
                    ShowOrders();
                end;
            }
        }
    }
    var
        Quantity: Integer;
        GudfoodOrderLine: Record "Gudfood Order Line";
        GudfoodOrderLineList: Page "Gudfood Order Subpage";

    trigger OnClosePage()
    begin
        GudfoodOrderLineList.ChangeVisable(false);
    end;

    trigger OnAfterGetRecord()
    begin
        GudfoodOrderLine.SetRange(GudfoodOrderLine."Item No.", Rec.Code);
        Quantity := GudfoodOrderLine.Count();
    end;

    local procedure ShowDetails()
    begin
        PAGE.Run(PAGE::"Gudfood Item Card", Rec);
    end;

    local procedure ShowOrders()
    begin
        GudfoodOrderLine.SetRange(GudfoodOrderLine."Item No.", Rec.Code);
        GudfoodOrderLineList.ChangeVisable(true);
        GudfoodOrderLineList.SetTableView(GudfoodOrderLine);
        GudfoodOrderLineList.Run();
    end;
}