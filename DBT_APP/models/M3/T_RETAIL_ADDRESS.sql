SELECT 
    H.DIVI AS Division, 
    L.ORNO AS [Order Number], 
    L.ADRT AS [Address Type], 
    L.ADID AS [Address Number], 
    L.CUNM AS Name, 
    L.CUA1 AS [Address Line 1], 
    L.CUA2 AS [Address Line 2], 
    L.CUA3 AS [Address Line 3], 
    L.CUA4 AS [Address Line 4], 
    L.PONO AS [Postal Code], 
    L.PHNO AS [Telephone Number 1], 
    L.YREF AS Reference, 
    L.CSCD AS Country, 
    L.GEOC AS [Geographical Code], 
    L.TAXC AS [Tax Code Customer], 
    L.ECAR AS State, 
    L.MODL AS [Delivery Method], 
    L.TEDL AS [Delivery Terms], 
    L.TEL2 AS [Terms Text], 
    L.TOWN AS City

FROM dbo.OOADRE L

INNER JOIN dbo.OOHEAD H ON H.ORNO = L.ORNO 
    AND H.ORTP IN ('EC1', 'EC2', 'POS', 'PS1', 'SRW', 'SRP')
    AND L.ADRT = '1'

WHERE 
    L.deleted = 'N' 
    AND H.deleted = 'N'


