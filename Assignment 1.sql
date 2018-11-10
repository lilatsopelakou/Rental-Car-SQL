
CREATE TABLE Category (
    categoryId VARCHAR(40) NOT NULL,
    categoryLabel VARCHAR(40),
    categoryDesc VARCHAR(40),
    PRIMARY KEY (categoryId)
)

CREATE TABLE Location (
    locationId VARCHAR(40) NOT NULL,
    street VARCHAR(40) ,
    numbers VARCHAR(40) ,
    city VARCHAR(40) ,
    state VARCHAR(40) ,
    country VARCHAR(40),
    PRIMARY KEY (locationId)
)

CREATE TABLE Car(
VIN VARCHAR(40) NOT NULL,
categoryId VARCHAR(40) ,
locationId VARCHAR(40) ,
brand VARCHAR(40) ,
color VARCHAR(40) ,
model VARCHAR(40) ,
description VARCHAR(40) ,
purchaseDate date ,
PRIMARY KEY (VIN),
CONSTRAINT locationId FOREIGN KEY (locationId) REFERENCES 
Location (locationId) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT categoryId FOREIGN KEY (categoryId) REFERENCES
Category (categoryId) ON UPDATE CASCADE ON DELETE CASCADE
)


CREATE TABLE LocPhone (
    phoneNum VARCHAR(40) NOT NULL,
    LocId VARCHAR(40),
    PRIMARY KEY (phoneNum,LocId),
    CONSTRAINT LocId FOREIGN KEY (LocId)REFERENCES 
    Location (locationId) ON UPDATE CASCADE ON DELETE CASCADE)



CREATE TABLE Customer (
	customerId VARCHAR(40) NOT NULL,
    firstName VARCHAR(40) ,
    lastName VARCHAR(40) ,
    email VARCHAR(40) ,
    SSN VARCHAR(40) ,
    mobileNum VARCHAR(40) ,
    stateAbbrev VARCHAR(40) ,
    state VARCHAR(40) ,
    country VARCHAR(40),
    PRIMARY KEY (customerId)
)


CREATE TABLE Rental (
    reservationNum VARCHAR(40) NOT NULL,
    amount DOUBLE ,
    customerId VARCHAR(40),
    carVIN VARCHAR(40),
    pickUpLocation VARCHAR(40),
    returnLocation VARCHAR(40),
    pickUpDate DATE ,
    returnDate DATE ,
    PRIMARY KEY (reservationNum),
    CONSTRAINT carVIN FOREIGN KEY (carVIN)
        REFERENCES Car (VIN) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT customerId FOREIGN KEY (customerId)
        REFERENCES Customer (customerId)ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT pickUpLocation FOREIGN KEY (pickUpLocation)
        REFERENCES Location (locationId) ON UPDATE CASCADE ON DELETE CASCADE
)

SELECT reservationNum,pickupLocation
FROM Rental
WHERE pickupDate='2015-05-01'

SELECT DISTINCT c.firstName, c.lastName, c.mobileNum
FROM customer as c, rental as R, category as t, car
WHERE c.customerId= r.customerId AND r.carVIN=CAR.VIN AND car.categoryId=t.categoryId AND t.categoryLabel='luxury';

SELECT pickupLocation,count(carVIN)
FROM rental
GROUP BY pickUpLocation;

SELECT car.categoryId,
EXTRACT(Month from r.pickupDate) AS MONTH
,count(r.carVIN) as TOTAL_AMOUNT_OF_RENTALS
FROM rental as r, car
WHERE r.carVIN=car.VIN
GROUP BY car.categoryId,EXTRACT(Month from r.pickupDate);

CREATE view State AS
SELECT l.state,t.categoryLabel,count(reservationNum) AS Rentals
FROM Rental as r, Location as l, car as c, category as t
WHERE r.pickupLocation =l.locationId AND r.carVIN=c.VIN AND c.categoryId=t.categoryId
GROUP BY l.state,t.categoryLabel ;


select state,categoryLabel,max(rentals)
from state
group by state

CREATE view transpose as
SELECT l.state,count(r.reservationNum) as Rentals
FROM rental as r, Location as l
WHERE r.pickupLocation=l.locationId AND
(l.state="NY" OR l.state="NJ" OR l.state="CA")
AND EXTRACT(year from r.pickupDate)="2015"
AND EXTRACT(month from r.pickupDate)="5"
GROUP BY l.state;


SELECT 
sum(if(state="NY",rentals,0)) AS 'NY',
sum(if(state="NJ",rentals,0)) AS 'NJ',
sum(if(state="CA",rentals,0)) AS 'CA'
from transpose;



SELECT 
    YEAR(pickupdate) AS yr,
    MONTH(pickupdate) AS mnth,
    COUNT(reservationNum) AS counter
FROM
    Rental
WHERE
    amount > ALL (SELECT AVG(amount)
        FROM
            Rental
        
            AND reservationNum in (SELECT reservationNum
            FROM
                Rental
            WHERE
                YEAR(pickupdate) = '2015')
                GROUP BY MONTH(pickupdate))
GROUP BY MONTH(pickupdate)

SELECT YEAR(r.pickupdate) AS yr, MONTH(r.pickupdate) AS mnth,
count(r.reservationNum) AS counter
FROM rental as r
WHERE year(r.pickupdate)= '2015' AND r.amount>(SELECT avg(a.amount)
 FROM rental as a 
 WHERE month(r.pickupdate)=month(a.pickupdate)
 and year(r.pickupdate)=year(a.pickupdate)
 GROUP BY month(r.pickupdate))
 GROUP BY month(r.pickupdate)