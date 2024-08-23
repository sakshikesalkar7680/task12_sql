select * from sales

create table report_table(
	product_id varchar primary key,
	sum_of_sales float,
	sum_of_profit float
)

create or replace function update_product_report()
returns trigger as $$
declare
       sumofsales float;
       sumofprofit float;
       count_report int;
begin
     select sum(sales), sum(profit) into sumofsales, sumofprofit from sales
where product_id = new.product_id;

select count(*) into count_report from report_table where product_id = new.product_id;

if count_report = 0 then
insert into report_table values (new.product_id, sumofsales, sumofprofit);
else
update report_table set sum_of_sales = sumofsales, sumofprofit = sumofprofit
where product_id = new.product_id;
end if;
return new;
end
$$ language plpgsql

create trigger update_report_trigger
after insert on sales for each row execute function update_product_report()

select * from sales

select sum(sales), sum(profit) from sales where product_id = 'OFF-ST-10003208'


