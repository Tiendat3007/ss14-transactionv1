create database ClinicDB;
use ClinicDB;

create table if not exists patients (
	patient_id varchar(5) primary key,
    full_name varchar(100) not null,
    gender varchar(10),
    phone varchar(15) unique not null,
    address varchar(100)
);

create table if not exists doctors (
	doctor_id varchar(5) primary key,
    doctor_name varchar(100) not null,
    specialization varchar(50) not null,
    service_price	decimal(10,2) not null,
    status varchar(20) not null
);

create table if not exists appointments (
	appointment_id int primary key auto_increment,
	patient_id varchar(5),
    doctor_id varchar(5),
    appointment_date date not null,
    shift_time varchar(20),
    constraint fk_patient_id foreign key (patient_id) references patients(patient_id),
    constraint fk_doctor_id foreign key (doctor_id) references doctors(doctor_id)
);

create table if not exists prescriptions (
	prescription_id int auto_increment primary key,
	appointment_id int,
    diagnosis varchar(255),
    total_cost decimal(10,2) not null,
    created_date date not null,
    constraint fk_appointment_id foreign key (appointment_id) references appointments(appointment_id)
);

insert into patients
values 
	('P01','nguyen van an','nam','0988111111','Ha Noi'),
    ('P02','Tran Thi Binh','nu','0988222222','HCM'),
    ('P03','Le Van Cuong','nam','0988333333','Da Nang'),
    ('P04','Pham Thi Dung','nu','0988444444	','Ha Noi'),
    ('P05','Hoang Van Em','nam','0988555555','Can Tho');
    
insert into doctors
values 
	('D01','Dr. Alice','Noi Khoa','200.00','active'),
    ('D02','Dr. Bob	','Nhi Khoa','150.00','active'),
    ('D03','Dr. Charlie','Rang Ham Mat','30000','on leave'),
    ('D04','Dr. David','Noi Khoa','220.00	','active'),
    ('D05','Dr. Eve','Da lieu','250.00','retired');
    
insert into appointments
values 
	('1','P01','D01','2025-06-01','sang'),
    ('2','P02','D02','2025-06-02','chieu'),
    ('3','P03','D03','2025-06-03','sang'),
    ('4','P01','D04','2025-06-04','chieu'),
    ('5','P05','D02','2025-06-05','sang');
    
insert into prescriptions 
values 
	('1','1','viem hong','500.00','2025-06-01'),
    ('2','2','sot xuat huye','800.00','2025-06-02'),
    ('3','3','nho rang','400.00','2025-06-03'),
    ('4','4','dau da tay','600.00','2025-06-04'),
    ('5','5','di ung da','300.00','2025-06-05');
    
update  patients 
set address = 'hue'
where patient_id='P03';

update  doctors 
set status = 'Retired'
where doctor_id='D05';

set sql_safe_updates = 0;
delete from prescriptions
where total_cost <4000 and created_date <'2025-06-04';

-- truy van
select * from doctors 
where specialization ='Noi Khoa' and service_price >200;

-- lay thong tin gioi tinh nu
select full_name,phone from patients
where gender = 'nu';
-- lay 3 don thuoc co gia tri cao nhat
select * from prescriptions 
order by total_cost desc
limit 3;
-- danh sach benh nhan bo qua 1 va lay 3
select * from appointments
limit 3
offset 1;
-- 

select a.appointment_id, p.full_name, d.doctor_name, pr.diagnosis, pr.total_cost 
from appointments a
join patients p on a.patient_id	= p.patient_id
join doctors d on a.doctor_id = d.doctor_id
join prescriptions pr on a.appointment_id = pr.appointment_id

	