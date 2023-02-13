select * from ranges;

/*
1, 2, 5
1, 7, 1250
1,3000, 3050
1, 5116,5118


1st step 
subselect 
one row
contains all numbers from minimal rfrom to max rto

2nd step: unpack data
1,2,2
1,3,3
1,4,4
1,5,5
1,7,7
...
1,1250,1250
...

*/
with numbers(n) as (
select min(rfrom) n from ranges
union all
select n+1 n from numbers where n< (select max(rto) from ranges)
),
unpacked as (
select distinct fk_sim,num.n rfrom
from ranges r
left join numbers num on num.n between r.rfrom and r.rto 
), 
grouped as(
    select fk_sim, rfrom, rfrom - row_number() over (partition by fk_sim order by rfrom) grp
    from unpacked u
) 
select fk_sim, min(rfrom) rfrom, max(rfrom) rto
from grouped
group by fk_sim, grp
order by fk_sim, rfrom
/*
select fk_sim, min(rfrom) rfrom, max(rfrom) rto
from grouped
group by fk_sim, grp
order by fk_sim, rfrom;*/