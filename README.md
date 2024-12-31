# Suzano-Analise_de_Dados_Power_BI

Foi criado uma base de chamada "eccommerce_BD" contendo 14 tabelas e suas relações e todas foram populadas.
As querys de teste são a seguinte:
1 - query buscando todos os clientes (Pf) cujo primeiro nome começa com C, usado um LIKE para filtrar a busca;
2 - query usando WITH para trazer os dados de todos os clientes fisicos e juridicos, contendo nome sobrenome, a descrição do pedido feito e o valor do frete, utilizado JOIN, WITH, CONCAT e FORMAT;
3 - query onde foi feito os joins entre 7 tabelas para trazer uma série de dados relacionados ao comprador, descrição da compra, tipos de pagamento, disponibilidade, nome do  produto, descrição do produto, se é infantil ou não, a avaliação dos usuários em relação ao produto comprado, e as dimensões do produto;

Segue abaixo as querys:

select * from customer c inner join naturalPerson np on c.idcustomer = np.idnperson where np.fname like 'C%';


select * from customer c inner join naturalPerson np on c.idcustomer = np.idnperson where np.lname = 'Oliveira' or np.lname = 'Pereira' order by fname, lname asc;
with	d1 as (
	select idnperson, fname from naturalPerson
    ),	d2 as(
    select idlentity, socialreason from legalEntity
    )
select c.idcustomer, d1.idnperson, d1.fname from customer c join d1 on c.idcustomer = d1.idnperson;



with	d1 as (
	select idcustomer from Customer
    ),
		d2 as (
	select idnperson, fname, lname from naturalPerson
    ),	d3 as(
    select idlentity, socialreason from legalEntity
    )
select d2.fname as 'nome', d2.lname as 'sobrenome', o.orderdescription as 'descricao', concat('R$ ', format(o.shippingvalue, 2, 'pt_BR')) as 'frete'
from orders o 
join d1 d1 on idorderclient = idcustomer
join d2 d2 on d1.idcustomer = d2.idnperson;


select 
		c.idcustomer, 
		case 
			when c.idcustomer = np.idnperson
				then (select concat( np.fname, ' ', np.lname, ', '))
			when c.idcustomer = le.idlentity
				then (select concat( le.socialreason, ', '))
			else ''
        end as comprador,
        o.orderdescription as 'descricao da compra',
        concat('R$ ', format(o.shippingvalue, 2, 'pt_BR')) as 'frete',
		pay.typePayment as 'tipo pagamento',
		pay.limitAvaliable as 'limite do cliente',
        payo.idPOrder as 'id ordem de pagamento',
		pord.poQuantity as 'quantidade pedido',
		pord.poStatus as 'status pedido',
        prod.idProduct as 'id do produto',
		prod.pName as 'nome produto',
		case when prod.kids = True then 'produto infantil' else 'não indicado' end as 'para criança?',
		prod.category,
		prod.avaliation,
		prod.size
from customer c
left join orders o on o.idorderclient = c.idcustomer
left join naturalperson np on c.idcustomer = np.idnperson
left join legalentity le on c.idcustomer = le.idlentity
left join payment pay on c.idcustomer = pay.idcustomer
inner join paymentorder payo on o.idorder = payo.idporder and pay.idpayment = payo.idppayment
left join productorder pord on o.idorder = pord.idpoorder
left join product prod on pord.idpoproduct = prod.idproduct;
