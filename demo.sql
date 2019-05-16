#use pos_system;
#Select * from employee;
#Select * from manager;

#Select m.EmployeeName AS managerName, e.EmployeeName
#From employee e
#INNER JOIN manager m
#on e.ManagerID = m.ManagerID;

#select * from store;

#Select StoreID, COUNT(*) from employee
#Group By StoreID;

#select * from transactions;

#Select EmployeeName, Sum(FinalCost) as TotalAmountSold
#From employee
#Inner Join transactions
#on employee.EmployeeID = transactions.EmployeeID
#Group by EmployeeName;

#select CardHolderName, CashValue, FinalCost, CardNumber
#from billing
#inner join transactions
#on transactions.TransactionID = billing.TransactionID;

#select * from warehouse;

#select warehouse.Address as WarehouseAddress,
#name, customer.Address as CustomerAddress, product.ProductName
#from warehouselog
#inner join customer
#on warehouselog.CustomerID = customer.CustomerID
#inner join warehouse
#on warehouselog.WarehouseID = warehouse.warehouseID
#inner join product
#on warehouselog.ItemNumber = product.ItemNumber;