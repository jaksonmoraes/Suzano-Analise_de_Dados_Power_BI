create database if not exists eccommerce;
use eccommerce;

create table customer(
	idCustomer int auto_increment primary key,
    contact char(11) not null,
    address varchar(30)
);

create table legalEntity(
	idLEntity int auto_increment primary key,
    cnpj char(15) not null,
    socialReason varchar(255) not null,
    constraint fk_legal_entity_customer foreign key (idLEntity) references customer(idCustomer)
);

create table naturalPerson(
	idNPerson int auto_increment primary key,
    cpf char(11) not null,
    fName varchar(15),
    m_init char(3),
    lName varchar(25),
    constraint fk_natural_person_customer foreign key (idNPerson) references customer(idCustomer)
);

create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('cancelado', 'confirmado', 'processando') default 'processando',
    orderDescription varchar(255),
    shippingValue float default 10,
    paymentCash bool default false,
    constraint fk_orders_customer foreign key(idOrderClient) references customer(idCustomer)
			on update cascade
    );

create table product(
	idProduct int auto_increment primary key,
    pName varchar(15) not null,
    kids bool default false,
    category enum('eletronico', 'vestimenta', 'brinquedos', 'alimentos', 'moveis') not null,
    avaliation float default 0,
    size varchar(12)
);

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('disponivel', 'sem estoque') default 'disponivel',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
    );

create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location__storage foreign key (idLstorage) references productStorage(idProdStorage)
    );
    
create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
	);

create table payment(
	idCustomer int,
    idPayment int,
    typePayment enum('boleto', 'cartao', 'dois cartoes'),
    limitAvaliable float,
    primary key(idPayment),
    constraint fk_payment_customer foreign key (idCustomer) references customer(idCustomer)
    );

create table paymentOrder(
	idPOrder int,
	idPPayment int,
    primary key(idPOrder, idPPayment),
    constraint fk_payment_order_orders foreign key (idPOrder) references orders(idOrder),
    constraint fk_payment_order_payment foreign key (idPPayment) references payment(idPayment)
);

create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
    );

create table supplier(
	idSupplier int auto_increment primary key,
    socialReason varchar(255) not null,
    cnpj char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (cnpj)
    );

create table seller(
	idSeller int auto_increment primary key,
    socialReason varchar(255) not null,
    abstName varchar(255),
    cnpj char(15) not null,
    cpf char(11),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (cnpj),
    constraint unique_cpf_seller unique (cpf)
    );

create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key(idPseller, idPproduct),
    constraint fk_product_seller foreign key(idPseller) references seller(idSeller),
    constraint fk_product_product foreign key(idPproduct) references product(idProduct)
    );
