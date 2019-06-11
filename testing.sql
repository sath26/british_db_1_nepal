declare 
b number;
begin 
dbms_output.put_line('program started');
for a in 1..3
loop
b:=1;
while (a>=b)
loop
dbms_output.put_line(a);
b:=b+1;
end loop;
end loop;
end; 