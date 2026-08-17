--sfsc / SFSC123 @shscdev
WITH check_list AS (SELECT   DISTINCT acc_ym, real_acc_ym, id
                      FROM   sfsc.rcv_check_sc_rcv
                     WHERE   acc_ym >= '202509'
                    UNION
                    SELECT   DISTINCT acc_ym, real_acc_ym, id
                      FROM   sfsc.rcv_check_hrally_rcv
                     WHERE   acc_ym >= '202509'),
    sc_rcv AS (  SELECT   acc_ym,
                          id,
                          real_acc_ym,
                          emp_no,
                          name,
                          company_no,
                          company_name,
                          SUM (NVL (oep_comp_val, 0)) oep_comp_val,
                          SUM (NVL (med_comp_val, 0)) med_comp_val,
                          SUM (NVL (los_comp_val, 0)) los_comp_val,
                          SUM (NVL (inj_comp_val, 0)) inj_comp_val,
                          SUM (NVL (bir_comp_val, 0)) bir_comp_val,
                          SUM (NVL (oep_emp_val, 0)) oep_emp_val,
                          SUM (NVL (med_emp_val, 0)) med_emp_val,
                          SUM (NVL (los_emp_val, 0)) los_emp_val,
                          SUM (NVL (inj_emp_val, 0)) inj_emp_val,
                          SUM (NVL (bir_emp_val, 0)) bir_emp_val,
                          SUM (NVL (fundb_comp_val, 0)) fundb_comp_val,
                          SUM (NVL (funda_comp_val, 0)) funda_comp_val,
                          SUM (NVL (fundb_emp_val, 0)) fundb_emp_val,
                          SUM (NVL (funda_emp_val, 0)) funda_emp_val,
                          SUM (NVL (adm_fee, 0)) adm_fee,
                          SUM (NVL (total_val, 0)) total_val,
                          SUM (NVL (wage_pay, 0)) wage_pay
                   FROM   sfsc.rcv_check_sc_rcv
                  WHERE   acc_ym >= '202509'
               GROUP BY   acc_ym,
                          id,
                          real_acc_ym,
                          emp_no,
                          name,
                          company_no,
                          company_name),
    hrally_rcv
       AS (  SELECT   acc_ym,
                      id,
                      real_acc_ym,
                      udid,
                      name,
                      company_name,
                      SUM (NVL (oep_comp_val, 0)) oep_comp_val,
                      SUM (NVL (oep_emp_val, 0)) oep_emp_val,
                      SUM (NVL (med_comp_val, 0)) med_comp_val,
                      SUM (NVL (med_emp_val, 0)) med_emp_val,
                      SUM (NVL (los_comp_val, 0)) los_comp_val,
                      SUM (NVL (los_emp_val, 0)) los_emp_val,
                      SUM (NVL (inj_comp_val, 0)) inj_comp_val,
                      SUM (NVL (inj_emp_val, 0)) inj_emp_val,
                      SUM (NVL (bir_comp_val, 0)) bir_comp_val,
                      SUM (NVL (bir_emp_val, 0)) bir_emp_val,
                      SUM (NVL (warm_val, 0)) warm_val,
                      SUM (NVL (ill_total_val, 0)) ill_total_val,
                      SUM (NVL (union_val, 0)) union_val,
                      SUM (NVL (dis_val, 0)) dis_val,
                      SUM (NVL (late_val, 0)) late_val,
                      SUM (NVL (other_social, 0)) other_social,
                      SUM (NVL (fundb_comp_val, 0)) fundb_comp_val,
                      SUM (NVL (fundb_emp_val, 0)) fundb_emp_val,
                      SUM (NVL (funda_comp_val, 0)) funda_comp_val,
                      SUM (NVL (funda_emp_val, 0)) funda_emp_val,
                      SUM (NVL (adm_fee, 0)) adm_fee,
                      SUM (NVL (payroll_fee, 0)) payroll_fee,
                      SUM (NVL (doc_fee, 0)) doc_fee,
                      SUM (NVL (total_payable_val, 0)) total_payable_val
               FROM   sfsc.rcv_check_hrally_rcv
              WHERE   acc_ym >= '202509'
           GROUP BY   acc_ym,
                      id,
                      real_acc_ym,
                      udid,
                      name,
                      company_name)
SELECT   d.party_short_name 关联方,
         a.acc_ym 账单年月,
         a.real_acc_ym 业务年月,
         b.name "上海速创-姓名",
         c.name "聚合力-姓名",
         a.id 身份证,
         b.company_no "上海速创-客户编号",
         b.company_name "上海速创-客户简称",
         d.comp_grp_name "上海速创-客户组",
         b.emp_no "上海速创-雇员编号",
         c.company_name "聚合力-客户",
         c.udid "聚合力-雇员编号",
         nvl(b.oep_comp_val,0) + nvl(b.med_comp_val,0) + nvl(b.los_comp_val,0) + nvl(b.inj_comp_val,0) + nvl(b.bir_comp_val,0) 
         + nvl(b.oep_emp_val,0) + nvl(b.med_emp_val,0) + nvl(b.los_emp_val,0) + nvl(b.inj_emp_val,0) + nvl(b.bir_emp_val,0)
         - nvl(c.oep_comp_val,0) - nvl(c.oep_emp_val,0) - nvl(c.med_comp_val,0) - nvl(c.med_emp_val,0) - nvl(c.los_comp_val,0) - nvl(c.los_emp_val,0) 
         - nvl(c.inj_comp_val,0) - nvl(c.inj_emp_val,0) - nvl(c.bir_comp_val,0) - nvl(c.bir_emp_val,0) - nvl(c.dis_val,0) "社保总计-对账差异",
         /*nvl(b.oep_comp_val,0), nvl(b.med_comp_val,0), nvl(b.los_comp_val,0), nvl(b.inj_comp_val,0), nvl(b.bir_comp_val,0),
         nvl(b.oep_emp_val,0), nvl(b.med_emp_val,0), nvl(b.los_emp_val,0), nvl(b.inj_emp_val,0), nvl(b.bir_emp_val,0),
         nvl(c.oep_comp_val,0), nvl(c.oep_emp_val,0), nvl(c.med_comp_val,0), nvl(c.med_emp_val,0), nvl(c.los_comp_val,0), nvl(c.los_emp_val,0), 
         nvl(c.inj_comp_val,0), nvl(c.inj_emp_val,0), nvl(c.bir_comp_val,0), nvl(c.bir_emp_val,0), */
         nvl(b.fundb_comp_val,0) + nvl(b.funda_comp_val,0) + nvl(b.fundb_emp_val,0) + nvl(b.funda_emp_val,0) - nvl(c.fundb_comp_val,0) - nvl(c.fundb_emp_val,0) - nvl(c.funda_comp_val,0) - nvl(c.funda_emp_val,0) "公积金总计-对账差异",
         nvl(b.adm_fee,0) - nvl(c.adm_fee,0) - nvl(c.payroll_fee,0) - nvl(c.doc_fee,0) "服务费总计-对账差异",
         nvl(b.total_val,0) - nvl(b.wage_pay,0) - nvl(c.total_payable_val,0) "对账金额总计-对账差异"
  FROM   check_list a, sc_rcv b, hrally_rcv c, rcv_check_comp d
 WHERE   a.id = b.id(+)
   AND   a.acc_ym = b.acc_ym(+)
   AND   a.real_acc_ym = b.real_acc_ym(+)
   AND   a.id = c.id(+)
   AND   a.acc_ym = c.acc_ym(+)
   AND   a.real_acc_ym = c.real_acc_ym(+)
   and   b.company_no = d.company_no(+)
   --and   a.id = '310110199012145613'
   --and   d.party_short_name is null and b.company_no is not null  --检查是否存在新增收包客户
   --and   c.name = '戴永菡'
   --and   a.id in ('307726954','TWN004392321')
 order by a.acc_ym, d.party_short_name, b.company_no, a.id, a.real_acc_ym
 
--速创应收
WITH check_list AS (SELECT   DISTINCT acc_ym, real_acc_ym, id, name, 'sc' data_src
                      FROM   sfsc.rcv_check_sc_rcv
                     WHERE   acc_ym >= '202510'
                    UNION
                    SELECT   DISTINCT acc_ym, real_acc_ym, id, name, 'hrally' data_src
                      FROM   sfsc.rcv_check_hrally_rcv
                     WHERE   acc_ym >= '202510')
select * from check_list
where name = '白靖国'

--聚合力应付
WITH hrally_rcv
       AS (  SELECT   acc_ym,
                      id,
                      real_acc_ym,
                      udid,
                      name,
                      company_name,
                      SUM (NVL (oep_comp_val, 0)) oep_comp_val,
                      SUM (NVL (oep_emp_val, 0)) oep_emp_val,
                      SUM (NVL (med_comp_val, 0)) med_comp_val,
                      SUM (NVL (med_emp_val, 0)) med_emp_val,
                      SUM (NVL (los_comp_val, 0)) los_comp_val,
                      SUM (NVL (los_emp_val, 0)) los_emp_val,
                      SUM (NVL (inj_comp_val, 0)) inj_comp_val,
                      SUM (NVL (inj_emp_val, 0)) inj_emp_val,
                      SUM (NVL (bir_comp_val, 0)) bir_comp_val,
                      SUM (NVL (bir_emp_val, 0)) bir_emp_val,
                      SUM (NVL (warm_val, 0)) warm_val,
                      SUM (NVL (ill_total_val, 0)) ill_total_val,
                      SUM (NVL (union_val, 0)) union_val,
                      SUM (NVL (dis_val, 0)) dis_val,
                      SUM (NVL (late_val, 0)) late_val,
                      SUM (NVL (other_social, 0)) other_social,
                      SUM (NVL (fundb_comp_val, 0)) fundb_comp_val,
                      SUM (NVL (fundb_emp_val, 0)) fundb_emp_val,
                      SUM (NVL (funda_comp_val, 0)) funda_comp_val,
                      SUM (NVL (funda_emp_val, 0)) funda_emp_val,
                      SUM (NVL (adm_fee, 0)) adm_fee,
                      SUM (NVL (payroll_fee, 0)) payroll_fee,
                      SUM (NVL (doc_fee, 0)) doc_fee,
                      SUM (NVL (total_payable_val, 0)) total_payable_val
               FROM   sfsc.rcv_check_hrally_rcv
              WHERE   acc_ym >= '202509'
           GROUP BY   acc_ym,
                      id,
                      real_acc_ym,
                      udid,
                      name,
                      company_name)
select * from hrally_rcv
where id = '310104197512315627'

--新增收包客户
select distinct company_no
from sfsc.rcv_check_sc_rcv a
where not exists (
select 1 from rcv_check_comp
where company_no = a.company_no
)

--速创收包客户清单（含关联方和客户组）
select a.company_no, a.shortname, a.party_code, b.short_name, c.comp_grp_name
from sfsc.fs_client a, sfsc.fs_finc_related_party b, sfsc.fs_comp_group c
where manage_dept = 'Z4'
and a.party_code = b.party_code(+)
and a.comp_grp_code = c.comp_grp_code
and company_no in ('CH79472','CH79328','CH79471','CH79551')
--and company_no = 'CH38727'

--每批次导入数据
delete from sfsc.rcv_check_sc_rcv

delete from sfsc.rcv_check_hrally_rcv

select * from sfsc.rcv_check_sc_rcv for update

select * from sfsc.rcv_check_hrally_rcv for update

update sfsc.rcv_check_sc_rcv
set acc_ym = '202510'

delete from sfsc.rcv_check_comp

select * from sfsc.rcv_check_comp for update