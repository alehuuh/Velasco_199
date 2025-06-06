USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[sp_MSupd_dbostudent_subject080895329301714623882]    Script Date: 5/23/2025 10:14:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_MSupd_dbostudent_subject080895329301714623882]
			@c1 varchar(50) = NULL,
			@c2 varchar(50) = NULL,
			@c3 varchar(50) = NULL,
			@pkc1 varchar(50) = NULL,
			@bitmap binary(1),
			@MSp2pPreVersion varbinary(32), @MSp2pPostVersion varbinary(32),
			@Offset bigint = -1, @Length bigint = -1, @partcol int = -1
as
begin  
if (substring(@bitmap,1,1) & 1 = 1)
begin 

if @Offset < 0 and @Length < 0 and @partcol < 0
	update [dbo].[student_subject] set
			[studsubjectcode] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [studsubjectcode] end,
			[studcode] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [studcode] end,
			[subjectcode] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [subjectcode] end,
			$sys_p2p_cd_id = @MSp2pPostVersion
	where [studsubjectcode] = @pkc1
  and ($sys_p2p_cd_id = @MSp2pPreVersion or $sys_p2p_cd_id is null)
else if @partcol >= 0 begin
	declare @update_part_3 nvarchar(max)
	select @update_part_3 = case when t.name in (N'varchar', N'nvarchar', N'varbinary') and c.max_length = -1 then N'
update [dbo].[student_subject] set [' + replace(c.name,'''','''''') + N'].write(@c' + convert(nvarchar(10), @partcol) + N', @Offset, @Length), $sys_p2p_cd_id = @MSp2pPostVersion 
	where [studsubjectcode] = @pkc1
  and ($sys_p2p_cd_id = @MSp2pPreVersion or $sys_p2p_cd_id is null)
' when t.name in (N'text', N'ntext') then N'
declare @ptrvald varbinary(16) 
select @ptrvald = textptr([' + replace(c.name,'''','''''') + N']) from [dbo].[student_subject] 
	where [studsubjectcode] = @pkc1
  and ($sys_p2p_cd_id = @MSp2pPreVersion or $sys_p2p_cd_id is null)
if @ptrvald is NULL begin 
	update [dbo].[student_subject] set [' + replace(c.name,'''','''''') + N'] = NULL 
	where [studsubjectcode] = @pkc1
  and ($sys_p2p_cd_id = @MSp2pPreVersion or $sys_p2p_cd_id is null)
  and [' + replace(c.name,'''','''''') + N'] is NULL 
	select @ptrvald = textptr([' + replace(c.name,'''','''''') + N']) from [dbo].[student_subject] 
	where [studsubjectcode] = @pkc1
  and ($sys_p2p_cd_id = @MSp2pPreVersion or $sys_p2p_cd_id is null)
end 
if @ptrvald is not NULL begin 
	declare @iOffset int = @Offset, @iLength int = @Length
	updatetext [dbo].[student_subject].[' + replace(c.name,'''','''''') + N'] @ptrvald @iOffset @iLength with log @c' + convert(nvarchar(10), @partcol) + N'
	update [dbo].[student_subject] set $sys_p2p_cd_id = @MSp2pPostVersion 
	where [studsubjectcode] = @pkc1
end' else NULL end
			from (sys.columns c join sys.types t on ((c.system_type_id != 240 and c.system_type_id = t.user_type_id) or (c.system_type_id = 240 and c.user_type_id = t.user_type_id)))
			where c.object_id = OBJECT_ID(N'[dbo].[student_subject]') and c.column_id = @partcol
	if @update_part_3 is null
		return
	else
		exec sp_executesql
			@update_part_3,
			N' @c1 varchar(50), @c2 varchar(50), @c3 varchar(50), @pkc1 varchar(50), @MSp2pPreVersion varbinary(32), @MSp2pPostVersion varbinary(32), @Offset bigint, @Length bigint, @partcol int ',
			@c1,
			@c2,
			@c3,
			@pkc1,
			@MSp2pPreVersion, @MSp2pPostVersion,
			@Offset, @Length, @partcol 
end
end  
else
begin 

if @Offset < 0 and @Length < 0 and @partcol < 0
	update [dbo].[student_subject] set
			[studcode] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [studcode] end,
			[subjectcode] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [subjectcode] end,
			$sys_p2p_cd_id = @MSp2pPostVersion
	where [studsubjectcode] = @pkc1
  and ($sys_p2p_cd_id = @MSp2pPreVersion or $sys_p2p_cd_id is null)
else if @partcol >= 0 begin
	declare @update_part_4 nvarchar(max)
	select @update_part_4 = case when t.name in (N'varchar', N'nvarchar', N'varbinary') and c.max_length = -1 then N'
update [dbo].[student_subject] set [' + replace(c.name,'''','''''') + N'].write(@c' + convert(nvarchar(10), @partcol) + N', @Offset, @Length), $sys_p2p_cd_id = @MSp2pPostVersion 
	where [studsubjectcode] = @pkc1
  and ($sys_p2p_cd_id = @MSp2pPreVersion or $sys_p2p_cd_id is null)
' when t.name in (N'text', N'ntext') then N'
declare @ptrvald varbinary(16) 
select @ptrvald = textptr([' + replace(c.name,'''','''''') + N']) from [dbo].[student_subject] 
	where [studsubjectcode] = @pkc1
  and ($sys_p2p_cd_id = @MSp2pPreVersion or $sys_p2p_cd_id is null)
if @ptrvald is NULL begin 
	update [dbo].[student_subject] set [' + replace(c.name,'''','''''') + N'] = NULL 
	where [studsubjectcode] = @pkc1
  and ($sys_p2p_cd_id = @MSp2pPreVersion or $sys_p2p_cd_id is null)
  and [' + replace(c.name,'''','''''') + N'] is NULL 
	select @ptrvald = textptr([' + replace(c.name,'''','''''') + N']) from [dbo].[student_subject] 
	where [studsubjectcode] = @pkc1
  and ($sys_p2p_cd_id = @MSp2pPreVersion or $sys_p2p_cd_id is null)
end 
if @ptrvald is not NULL begin 
	declare @iOffset int = @Offset, @iLength int = @Length
	updatetext [dbo].[student_subject].[' + replace(c.name,'''','''''') + N'] @ptrvald @iOffset @iLength with log @c' + convert(nvarchar(10), @partcol) + N'
	update [dbo].[student_subject] set $sys_p2p_cd_id = @MSp2pPostVersion 
	where [studsubjectcode] = @pkc1
end' else NULL end
			from (sys.columns c join sys.types t on ((c.system_type_id != 240 and c.system_type_id = t.user_type_id) or (c.system_type_id = 240 and c.user_type_id = t.user_type_id)))
			where c.object_id = OBJECT_ID(N'[dbo].[student_subject]') and c.column_id = @partcol
	if @update_part_4 is null
		return
	else
		exec sp_executesql
			@update_part_4,
			N' @c1 varchar(50), @c2 varchar(50), @c3 varchar(50), @pkc1 varchar(50), @MSp2pPreVersion varbinary(32), @MSp2pPostVersion varbinary(32), @Offset bigint, @Length bigint, @partcol int ',
			@c1,
			@c2,
			@c3,
			@pkc1,
			@MSp2pPreVersion, @MSp2pPostVersion,
			@Offset, @Length, @partcol 
end
end 
if @@rowcount = 0
begin  
	declare @cur_version varbinary(32) 
		,@conflict_type int = 1
		,@conflict_type_txt nvarchar(20) = N'Update-Update'
		,@reason_code int = 1
		,@reason_text nvarchar(720) = NULL
		,@is_on_disk_winner bit = 0
		,@is_incoming_winner bit = 0
		,@peer_id_current_node int = NULL
		,@peer_id_incoming int
		,@tranid_incoming nvarchar(40)
		,@peer_id_on_disk int
		,@tranid_on_disk nvarchar(40)
        ,@cur_version_text nvarchar(40) = NULL
        ,@MSp2pPreVersion_text nvarchar(40) = convert(nvarchar(40), @MSp2pPreVersion, 1)
        ,@MSp2pPostVersion_text nvarchar(40) = convert(nvarchar(40), @MSp2pPostVersion, 1)
        ,@primarykey_text nvarchar(100) = ''
	select @peer_id_incoming = sys.fn_replvarbintoint(@MSp2pPostVersion)
		,@tranid_incoming = sys.fn_replp2pversiontotranid(@MSp2pPostVersion)
	select @cur_version = $sys_p2p_cd_id from [dbo].[student_subject] 
	where [studsubjectcode] = @pkc1
	if @@rowcount = 0  
			select @conflict_type = 3, @conflict_type_txt = N'Update-Delete', @is_on_disk_winner = 1, @reason_text = formatmessage(22823), @reason_code = 0
	else 
	begin  
		select @peer_id_on_disk = sys.fn_replvarbintoint(@cur_version)
			,@tranid_on_disk = sys.fn_replp2pversiontotranid(@cur_version)
		if(@peer_id_incoming > @peer_id_on_disk)
			set @is_incoming_winner = 1
		else
			set @is_on_disk_winner = 1
	end  
		select @peer_id_current_node = p.originator_id from syspublications p join sysarticles a on a.pubid = p.pubid where a.objid = object_id(N'[dbo].[student_subject]') and p.options & 0x1 = 0x1
	if (@peer_id_current_node is not null) 
	begin 
		if (@reason_text is NULL)
			if (@is_incoming_winner = 1)
			begin  
				select @reason_text = formatmessage(22822,@peer_id_incoming,@peer_id_on_disk,@peer_id_current_node)
			end  
			else  
			begin  
				select @reason_text = formatmessage(22821,@peer_id_incoming,@peer_id_on_disk,@peer_id_current_node)
			end  
		create table #change_id (change_id varbinary(8))
		insert [dbo].[conflict_dbo_student_subject] (
			[studsubjectcode],
			[studcode],
			[subjectcode]
			,__$originator_id
			,__$origin_datasource
			,__$tranid
			,__$conflict_type
			,__$is_winner
			,__$reason_code
			,__$reason_text
			,__$update_bitmap
			,__$pre_version)
		output inserted.__$row_id into #change_id
		select 
			@pkc1,
			@c2,
			@c3			,@peer_id_current_node
			,@peer_id_incoming
			,@tranid_incoming
			,@conflict_type
			,@is_incoming_winner
			,@reason_code
			,@reason_text
			,@bitmap
			,@MSp2pPreVersion
		insert [dbo].[conflict_dbo_student_subject] (

			[studsubjectcode],
			[studcode],
			[subjectcode]			,__$originator_id
			,__$origin_datasource
			,__$tranid
			,__$conflict_type
			,__$is_winner
			,__$reason_code
			,__$reason_text
			,__$pre_version
			,__$change_id)
		select 

			[studsubjectcode],
			[studcode],
			[subjectcode]			,@peer_id_current_node
			,@peer_id_on_disk
			,@tranid_on_disk
			,@conflict_type
			,@is_on_disk_winner
			,@reason_code
			,@reason_text
			,NULL
			,(select change_id from #change_id)
		from [dbo].[student_subject] 

	where [studsubjectcode] = @pkc1
	end 
	if(@is_incoming_winner = 1)
	begin  
if (substring(@bitmap,1,1) & 1 = 1)
begin 

if @Offset < 0 and @Length < 0 and @partcol < 0
	update [dbo].[student_subject] set
			[studsubjectcode] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [studsubjectcode] end,
			[studcode] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [studcode] end,
			[subjectcode] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [subjectcode] end,
			$sys_p2p_cd_id = @MSp2pPostVersion
	where [studsubjectcode] = @pkc1
else if @partcol >= 0 begin
	declare @update_part_5 nvarchar(max)
	select @update_part_5 = case when t.name in (N'varchar', N'nvarchar', N'varbinary') and c.max_length = -1 then N'
update [dbo].[student_subject] set [' + replace(c.name,'''','''''') + N'].write(@c' + convert(nvarchar(10), @partcol) + N', @Offset, @Length), $sys_p2p_cd_id = @MSp2pPostVersion 
	where [studsubjectcode] = @pkc1
' when t.name in (N'text', N'ntext') then N'
declare @ptrvald varbinary(16) 
select @ptrvald = textptr([' + replace(c.name,'''','''''') + N']) from [dbo].[student_subject] 
	where [studsubjectcode] = @pkc1
if @ptrvald is NULL begin 
	update [dbo].[student_subject] set [' + replace(c.name,'''','''''') + N'] = NULL 
	where [studsubjectcode] = @pkc1
  and [' + replace(c.name,'''','''''') + N'] is NULL 
	select @ptrvald = textptr([' + replace(c.name,'''','''''') + N']) from [dbo].[student_subject] 
	where [studsubjectcode] = @pkc1
end 
if @ptrvald is not NULL begin 
	declare @iOffset int = @Offset, @iLength int = @Length
	updatetext [dbo].[student_subject].[' + replace(c.name,'''','''''') + N'] @ptrvald @iOffset @iLength with log @c' + convert(nvarchar(10), @partcol) + N'
	update [dbo].[student_subject] set $sys_p2p_cd_id = @MSp2pPostVersion 
	where [studsubjectcode] = @pkc1
end' else NULL end
			from (sys.columns c join sys.types t on ((c.system_type_id != 240 and c.system_type_id = t.user_type_id) or (c.system_type_id = 240 and c.user_type_id = t.user_type_id)))
			where c.object_id = OBJECT_ID(N'[dbo].[student_subject]') and c.column_id = @partcol
	if @update_part_5 is null
		return
	else
		exec sp_executesql
			@update_part_5,
			N' @c1 varchar(50), @c2 varchar(50), @c3 varchar(50), @pkc1 varchar(50), @MSp2pPreVersion varbinary(32), @MSp2pPostVersion varbinary(32), @Offset bigint, @Length bigint, @partcol int ',
			@c1,
			@c2,
			@c3,
			@pkc1,
			@MSp2pPreVersion, @MSp2pPostVersion,
			@Offset, @Length, @partcol 
end
end  
else
begin 

if @Offset < 0 and @Length < 0 and @partcol < 0
	update [dbo].[student_subject] set
			[studcode] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [studcode] end,
			[subjectcode] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [subjectcode] end,
			$sys_p2p_cd_id = @MSp2pPostVersion
	where [studsubjectcode] = @pkc1
else if @partcol >= 0 begin
	declare @update_part_6 nvarchar(max)
	select @update_part_6 = case when t.name in (N'varchar', N'nvarchar', N'varbinary') and c.max_length = -1 then N'
update [dbo].[student_subject] set [' + replace(c.name,'''','''''') + N'].write(@c' + convert(nvarchar(10), @partcol) + N', @Offset, @Length), $sys_p2p_cd_id = @MSp2pPostVersion 
	where [studsubjectcode] = @pkc1
' when t.name in (N'text', N'ntext') then N'
declare @ptrvald varbinary(16) 
select @ptrvald = textptr([' + replace(c.name,'''','''''') + N']) from [dbo].[student_subject] 
	where [studsubjectcode] = @pkc1
if @ptrvald is NULL begin 
	update [dbo].[student_subject] set [' + replace(c.name,'''','''''') + N'] = NULL 
	where [studsubjectcode] = @pkc1
  and [' + replace(c.name,'''','''''') + N'] is NULL 
	select @ptrvald = textptr([' + replace(c.name,'''','''''') + N']) from [dbo].[student_subject] 
	where [studsubjectcode] = @pkc1
end 
if @ptrvald is not NULL begin 
	declare @iOffset int = @Offset, @iLength int = @Length
	updatetext [dbo].[student_subject].[' + replace(c.name,'''','''''') + N'] @ptrvald @iOffset @iLength with log @c' + convert(nvarchar(10), @partcol) + N'
	update [dbo].[student_subject] set $sys_p2p_cd_id = @MSp2pPostVersion 
	where [studsubjectcode] = @pkc1
end' else NULL end
			from (sys.columns c join sys.types t on ((c.system_type_id != 240 and c.system_type_id = t.user_type_id) or (c.system_type_id = 240 and c.user_type_id = t.user_type_id)))
			where c.object_id = OBJECT_ID(N'[dbo].[student_subject]') and c.column_id = @partcol
	if @update_part_6 is null
		return
	else
		exec sp_executesql
			@update_part_6,
			N' @c1 varchar(50), @c2 varchar(50), @c3 varchar(50), @pkc1 varchar(50), @MSp2pPreVersion varbinary(32), @MSp2pPostVersion varbinary(32), @Offset bigint, @Length bigint, @partcol int ',
			@c1,
			@c2,
			@c3,
			@pkc1,
			@MSp2pPreVersion, @MSp2pPostVersion,
			@Offset, @Length, @partcol 
end
end 
	end  
		set @primarykey_text = @primarykey_text + '[studsubjectcode] = ' + convert(nvarchar(100),@pkc1,1) + ', '
		set @cur_version_text = convert(nvarchar(40), @cur_version, 1) 
		if exists(select * from syspublications p join sysarticles a on a.pubid = p.pubid where a.objid = object_id(N'[dbo].[student_subject]') and p.options & 0x10 = 0x10)
			raiserror(22815, 10, -1, @conflict_type_txt, @peer_id_current_node, @peer_id_incoming, @tranid_incoming,  @peer_id_on_disk, @tranid_on_disk, N'[dbo].[student_subject]', @primarykey_text, @cur_version_text, @MSp2pPreVersion_text, @MSp2pPostVersion_text) with log
		else
			raiserror(22815, 16, -1, @conflict_type_txt, @peer_id_current_node, @peer_id_incoming, @tranid_incoming,  @peer_id_on_disk, @tranid_on_disk, N'[dbo].[student_subject]', @primarykey_text, @cur_version_text, @MSp2pPreVersion_text, @MSp2pPostVersion_text) with log
end 
end 
GO
