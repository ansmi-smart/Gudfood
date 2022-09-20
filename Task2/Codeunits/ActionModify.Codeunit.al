codeunit 50002 ActionModify
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnAfterConfirmPostSalesOrder(var SalesHeader: Record "Sales Header")
    begin
        /*if SalesHeader."Cust. Post. Description ANSMI" = '' then begin
            Error(AddDescriptionMessage);
        end else begin*/
        CustLedgerEntry.SetRange("Document Type", SalesHeader."Document Type");
        CustLedgerEntry."Cust. Post. Description ANSMI" := SalesHeader."Cust. Post. Description ANSMI";
        //end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnAfterConfirmPostPurchase()
    begin
        PurchInvHeader."Lines Counter ANSMI" := PurchaseHeader."Lines Counter ANSMI";
        PurchaceReceipt."Lines Counter ANSMI" := PurchaseHeader."Lines Counter ANSMI";
    end;

    var
        AddDescriptionMessage: Label 'Cust. Post. Description ANSM can`t be empty!';
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchaceReceipt: Record "Purch. Rcpt. Header";
        SalesOrder: Page "Sales Order";
}