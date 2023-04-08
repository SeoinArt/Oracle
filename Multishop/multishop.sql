DROP INDEX PK_upCategory;

/* 상위 카테고리 */
DROP TABLE upCategory 
	CASCADE CONSTRAINTS;

/* 상위 카테고리 */
CREATE TABLE upCategory (
	upcg_code NUMBER(8) NOT NULL, /* 상위 카테고리 코드 */
	upcg_name VARCHAR2(30) NOT NULL /* 상위 카테고리 명 */
);

COMMENT ON TABLE upCategory IS '상위 카테고리';

COMMENT ON COLUMN upCategory.upcg_code IS '상위 카테고리 코드';

COMMENT ON COLUMN upCategory.upcg_name IS '상위 카테고리 명';

CREATE UNIQUE INDEX PK_upCategory
	ON upCategory (
		upcg_code ASC
	);

ALTER TABLE upCategory
	ADD
		CONSTRAINT PK_upCategory
		PRIMARY KEY (
			upcg_code
		);
        
--------------------------------------------------------------------------------
DROP INDEX PK_downCategory;

/* 하위 카테고리 */
DROP TABLE downCategory 
	CASCADE CONSTRAINTS;

/* 하위 카테고리 */
CREATE TABLE downCategory (
	upcg_code NUMBER(8) NOT NULL, /* 상위 카테고리 코드 */
	downcg_code NUMBER(8) NOT NULL, /* 하위 카테고리 코드 */
	downcg_name VARCHAR2(30) NOT NULL /* 하위 카테고리명 */
);

COMMENT ON TABLE downCategory IS '하위 카테고리';

COMMENT ON COLUMN downCategory.upcg_code IS '상위 카테고리 코드';

COMMENT ON COLUMN downCategory.downcg_code IS '하위 카테고리 코드';

COMMENT ON COLUMN downCategory.downcg_name IS '하위 카테고리명';

CREATE UNIQUE INDEX PK_downCategory
	ON downCategory (
		upcg_code ASC,
		downcg_code ASC
	);

ALTER TABLE downCategory
	ADD
		CONSTRAINT PK_downCategory
		PRIMARY KEY (
			upcg_code,
			downcg_code
		);

ALTER TABLE downCategory
	ADD
		CONSTRAINT FK_upCategory_TO_downCategory
		FOREIGN KEY (
			upcg_code
		)
		REFERENCES upCategory (
			upcg_code
		);
--------------------------------------------------------------------------------
DROP INDEX PK_product;

/* 상품 */
DROP TABLE product 
	CASCADE CONSTRAINTS;

/* 상품 */
CREATE TABLE product (
	pnum NUMBER(8) NOT NULL, /* 상품 번호 */
	pname VARCHAR2(100) NOT NULL, /* 상품명 */
	price NUMBER(8) NOT NULL, /* 상품 정가 */
	saleprice NUMBER(8), /* 상품 판매가 */
	pcompany VARCHAR2(50), /* 제조사 */
	pcontents VARCHAR2(1000), /* 상품 설명 */
	pspec VARCHAR2(20), /* 상품 스펙 */
	point NUMBER(8), /* 포인트 */
	pindate DATE, /* 상품 입고일 */
	pimage1 VARCHAR2(100), /* 이미지1 */
	pimage2 VARCHAR2(100), /* 이미지2 */
	pimage3 VARCHAR2(100), /* 이미지3 */
	upcg_code NUMBER(8), /* 상위 카테고리 코드 */
	downcg_code NUMBER(8) /* 하위 카테고리 코드 */
);

COMMENT ON TABLE product IS '상품';

COMMENT ON COLUMN product.pnum IS '상품 번호';

COMMENT ON COLUMN product.pname IS '상품명';

COMMENT ON COLUMN product.price IS '상품 정가';

COMMENT ON COLUMN product.saleprice IS '상품 판매가';

COMMENT ON COLUMN product.pcompany IS '제조사';

COMMENT ON COLUMN product.pcontents IS '상품 설명';

COMMENT ON COLUMN product.pspec IS '상품 스펙';

COMMENT ON COLUMN product.point IS '포인트';

COMMENT ON COLUMN product.pindate IS '상품 입고일';

COMMENT ON COLUMN product.pimage1 IS '이미지1';

COMMENT ON COLUMN product.pimage2 IS '이미지2';

COMMENT ON COLUMN product.pimage3 IS '이미지3';

COMMENT ON COLUMN product.upcg_code IS '상위 카테고리 코드';

COMMENT ON COLUMN product.downcg_code IS '하위 카테고리 코드';

CREATE UNIQUE INDEX PK_product
	ON product (
		pnum ASC
	);

ALTER TABLE product
	ADD
		CONSTRAINT PK_product
		PRIMARY KEY (
			pnum
		);

ALTER TABLE product
	ADD
		CONSTRAINT FK_downCategory_TO_product
		FOREIGN KEY (
			upcg_code,
			downcg_code
		)
		REFERENCES downCategory (
			upcg_code,
			downcg_code
		);

ALTER TABLE product
	ADD
		CONSTRAINT FK_upCategory_TO_product
		FOREIGN KEY (
			upcg_code
		)
		REFERENCES upCategory (
			upcg_code
		);
--------------------------------------------------------------------------------
