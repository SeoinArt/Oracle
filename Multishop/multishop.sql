select * from member;

update member set mstate = 9 where idx =6;
update member set mstate = -1 where idx =4;
update member set mstate = -2 where idx =5;

commit;

select member.*, 
decode(mstate,0,'Ȱ��ȸ��',-1,'����ȸ��',-2,'Ż��ȸ��',9,'������') mstateStr from member 
order by idx desc;

update member set addr2='2����' where idx =2;