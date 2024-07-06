CREATE FUNCTION dbo.GetOrdersByCustomer (@CustomerId INT)
RETURNS TABLE
AS
RETURN (
    SELECT OrderId, OrderDate, TotalAmount
    FROM Orders
    WHERE CustomerId = @CustomerId
	)

;