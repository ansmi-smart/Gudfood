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
            PostedGudfoodOrderHeader."No." := GudfoodOrderHeader."Posting No.";
            PostedGudfoodOrderHeader.INSERT(TRUE);
            if (GudfoodOrderLine.FINDSET) then begin
                GudfoodOrderLine.SetRange("Order No.", GudfoodOrder."No.");
                GudfoodOrderLine.FINDSET();
                PostedGudfoodOrderLine.INIT;
                REPEAT
                    PostedGudfoodOrderLine.TRANSFERFIELDS(GudfoodOrderLine, TRUE);
                    PostedGudfoodOrderLine."Order No." := GudfoodOrderHeader."Posting No.";
                    PostedGudfoodOrderLine.INSERT(TRUE);
                UNTIL GudfoodOrderLine.NEXT = 0;
            end;

            GudfoodOrderHeader.DELETE(TRUE);
        END;
        MESSAGE(SuccesedTxt);
    end;
}
