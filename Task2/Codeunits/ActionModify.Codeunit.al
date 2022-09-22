codeunit 50002 ActionModify
{
    //1
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforePerformManualCheckAndRelease', '', false, false)]
    procedure OnBeforePerformManualCheckAndRelease(var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."Cust. Post. Description ANSMI" = '' then
            Error(AddDescriptionMessage);
    end;

    //2
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterInsertPostedHeaders', '', false, false)]
    local procedure OnAfterInsertPostedHeaders(var PurchaseHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ReturnShptHeader: Record "Return Shipment Header"; var PurchSetup: Record "Purchases & Payables Setup")
    begin
        PurchInvHeader."Lines Counter ANSMI" := PurchaseHeader."Lines Counter ANSMI";
        PurchRcptHeader."Lines Counter ANSMI" := PurchaseHeader."Lines Counter ANSMI";
        PurchRcptHeader.Modify();
    end;

    //3
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

    var
        AddDescriptionMessage: Label 'Cust. Post. Description ANSM can`t be empty!';
}