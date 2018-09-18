# TSQL Xquery Optimizations

## XQuery
1. Queries that use parent axis generate extra query plan steps so use multiple CROSS APPLY steps to get nodes at multiple nesting levels rather than using the parent axis.
    1. Bad
        ```
        select o.value(‘../@id’, ‘int’) as CustID, o.value(‘@id’, ‘int’) as OrdID
        from T
        cross apply x.nodes(‘/doc/customer/orders’) as N(o)
        ```
    1. Good
        ```
        select c.value(‘@id’, ‘int’) as CustID, o.value(‘@id’, ‘int’) as OrdID
        from T
        cross apply x.nodes(‘/doc/customer’) as N1(c)
        cross apply c.nodes(‘orders’) as N2(o)
        ```

1. Move ordinals to the end of path expressions
    1. Bad
        > /book[1]/@isbn
    1. Good
        > (/book/@isbn)[1]

1. Avoid predicates in the middle of path expressions
    1. Bad
        > book[@ISBN = “1-8610-0157-6”]/author[first-name = “Davis”]
    1. Good
        > /book[@ISBN = “1-8610-0157-6”] "n" /book/author[first-name = “Davis”]

1. Use context item in predicate to lengthen path in exist()
    1. Bad
        > SELECT * FROM docs WHERE 1 = xCol.exist(‘/book/subject[text() = “security”]’)
    1. Good
        > SELECT * FROM docs WHERE 1 = xCol.exist(‘/book/subject/text()[. = “security”]’)

1. Casting from XML to SQL
    1. Bad
        > CAST( CAST(xmldoc.query(‘/a/b/text()’) as nvarchar(500)) as int)
    1. Good
        > xmldoc.value(‘(/a/b/text())[1]’, ‘int’)
    1. Bad
        > node.query(‘.’).value(‘@attr’, ‘nvarchar(50)’)
    1. Good
        > node.value(‘@attr’, ‘nvarchar(50)’)

1. Use temp table (insert into #temp select … from nodes()) or Table-valued parameter instead of XML

1. Specify a single root node in query as the optimizer assumes that XML can be a fragment.