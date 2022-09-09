codeunit 50022 GudfoodOrderPost
{
    TableNo = "Gudfood Order Header";

    trigger OnRun()
    begin

    end;

    var
        PostedGudfoodOrderLine: Record "Posted Gudfood Order Line";
        GudfoodOrderLine: Record "Gudfood Order Line";
        PostedGudfoodOrderHeader: Record "Posted Gudfood Order Header";
        GudfoodOrderHeader: Record "Gudfood Order Header";
        SuccesedTxt: Label 'The order successfully posted!';

    procedure PostOrder(var GudfoodOrder: Record "Gudfood Order Header")
    begin
        IF GudfoodOrder."No." <> '' THEN BEGIN
            PostedGudfoodOrderHeader.INIT;
            GudfoodOrderHeader.GET(GudfoodOrder."No.");
            PostedGudfoodOrderHeader.TRANSFERFIELDS(GudfoodOrderHeader, TRUE);
            PostedGudfoodOrderHeader.INSERT(TRUE);
            PostedGudfoodOrderLine.INIT;
            GudfoodOrderLine.SETFILTER("Order No.", GudfoodOrder."No.");
            GudfoodOrderLine.FINDSET;
            REPEAT
                PostedGudfoodOrderLine.TRANSFERFIELDS(GudfoodOrderLine, TRUE);
                PostedGudfoodOrderLine.INSERT(TRUE);
            UNTIL GudfoodOrderLine.NEXT = 0;
            GudfoodOrderHeader.DELETE(TRUE);
        END;
        MESSAGE(SuccesedTxt);
    end;
}
