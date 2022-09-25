report 50022 "Gudfood Order Word"
{
    Caption = 'Gudfood Order Word';
    DefaultLayout = Word;
    WordLayout = 'WordReport.docx';

    dataset
    {
        dataitem(GudfoodOrderHeader; "Gudfood Order Header")
        {
            column(OrderDate; "Order Date")
            {

            }
            column(SelltoCustomerNo; "Sell- to Customer No.")
            {
            }
            column(SelltoCustomerName; "Sell- to Customer Name")
            {
            }
            column(PrinterPerson; Database.UserId)
            {

            }
            dataitem(GudfoodOrderLine; "Gudfood Order Line")
            {
                DataItemLink = "Order No." = FIELD("No.");

                column(ItemNo; "Item No.")
                {

                }
                column(ItemType; "Item Type")
                {

                }
                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(UnitPrice; "Unit Price")
                {

                }
                column(Amount; Amount)
                {

                }
                column(TotalAmount; TotalAmount)
                {

                }
            }

            trigger OnAfterGetRecord()
            begin
                TotalAmount := 0;
                if GudfoodOrderLine.FindSet() then begin
                    repeat
                        TotalAmount += GudfoodOrderLine.Amount;
                    until GudfoodOrderLine.Next() = 0;
                end;
            end;
        }
    }

    var
        TotalAmount: Decimal;
}
