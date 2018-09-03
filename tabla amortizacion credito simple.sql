declare @montoTotal decimal(18,8) = 250000,
	@tasaAnual decimal(18,8) = 15,
	@plazo int = 24,
	@cont int = 1;

set @tasaAnual = @tasaAnual /convert(decimal(18,6), 100)

declare @tasaMensual decimal(18,8) = @tasaAnual / 12;

declare @MontoPago decimal(18,8) = (@tasaMensual / (1-(POWER((1+@tasaMensual),(-1*@plazo))))) * @montoTotal;

declare @TablaAmort table(NumPago int, 
						Pago decimal(18,2),
						InteresesPagados decimal(18,2),
						CapitalPagado decimal(18,2),
						MontoPrestamo decimal(18,2))

insert @TablaAmort values(0,0,0,0,@montoTotal);

while(@plazo >= @cont)
begin	
	declare @saldoInsoluto decimal(18,8);
	if(@cont = 1)
	begin
		set @saldoInsoluto = @montoTotal;
	end
	declare @intereses decimal(18,8) = @tasaMensual * @saldoInsoluto;
	declare @pagoCapital decimal(18,8) = @MontoPago - @intereses	
	set @saldoInsoluto = @saldoInsoluto - @pagoCapital;
	insert @TablaAmort values(@cont,@MontoPago,@intereses,@pagoCapital, @saldoInsoluto);
	set @cont = @cont + 1;
end

select * from @TablaAmort;