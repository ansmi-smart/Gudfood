codeunit 50002 ActionModify
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCustomerEntry', '', false, false)]
    local procedure OnBeforePostCustomerEntry(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        GenJnlLine."Cust. Post. Description ANSMI" := SalesHeader."Cust. Post. Description ANSMI";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostCustOnAfterInitCustLedgEntry', '', false, false)]
    local procedure OnPostCustOnAfterInitCustLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var CustLedgEntry: Record "Cust. Ledger Entry"; Cust: Record Customer; CustPostingGr: Record "Customer Posting Group")
    begin
        CustLedgEntry."Cust. Post. Description ANSMI" := GenJournalLine."Cust. Post. Description ANSMI";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforePerformManualCheckAndRelease', '', false, false)]
    procedure OnBeforePerformManualCheckAndRelease(var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."Cust. Post. Description ANSMI" = '' then
            Error(AddDescriptionMessage);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnAfterConfirmPostPurchase()
    begin
        //not read yet
        PurchInvHeader."Lines Counter ANSMI" := PurchaseHeader."Lines Counter ANSMI";
        PurchaceReceipt."Lines Counter ANSMI" := PurchaseHeader."Lines Counter ANSMI";
    end;

    var
        AddDescriptionMessage: Label 'Cust. Post. Description ANSM can`t be empty!';
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchaceReceipt: Record "Purch. Rcpt. Header";
}