USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[sp_MSdel_dbocourses20961468941103571009]    Script Date: 5/23/2025 10:14:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_MSdel_dbocourses20961468941103571009]
			@pkc1 varchar(50),
			@MSp2pPreVersion varbinary(32) , @MSp2pPostVersion varbinary(32) 

as
begin  

	delete [dbo].[courses] 
	where [coursecode] = @pkc1
			and ($sys_p2p_cd_id = @MSp2pPreVersion or $sys_p2p_cd_id is null)
if @@rowcount = 0
begin  
	declare @cur_version varbinary(32) 
		,@conflict_type int = 2
		,@conflict_type_txt nvarchar(20) = N'Delete-Update'
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
	select @cur_version = $sys_p2p_cd_id from [dbo].[courses] 
	where [coursecode] = @pkc1
	if @@rowcount = 0  
			select @conflict_type = 4, @conflict_type_txt = N'Delete-Delete', @is_on_disk_winner = 1, @reason_text = formatmessage(22818)
	else 
	begin  
		select @peer_id_on_disk = sys.fn_replvarbintoint(@cur_version)
			,@tranid_on_disk = sys.fn_replp2pversiontotranid(@cur_version)
		if(@peer_id_incoming > @peer_id_on_disk)
			set @is_incoming_winner = 1
		else
			set @is_on_disk_winner = 1
	end  
		select @peer_id_current_node = p.originator_id from syspublications p join sysarticles a on a.pubid = p.pubid where a.objid = object_id(N'[dbo].[courses]') and p.options & 0x1 = 0x1
	if (@peer_id_current_node is not null) 
	begin 
		if (@reason_text is NULL)
			if (@is_incoming_winner = 1)
			begin  
				select @reason_text = formatmessage(22820,@peer_id_incoming,@peer_id_on_disk,@peer_id_current_node)
			end  
			else  
			begin  
				select @reason_code = 2, @reason_text = formatmessage(22819,@peer_id_incoming,@peer_id_on_disk,@peer_id_current_node)
			end  
		create table #change_id (change_id varbinary(8))
		insert [dbo].[conflict_dbo_courses] (
			[coursecode],
			[description]
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
			NULL			,@peer_id_current_node
			,@peer_id_incoming
			,@tranid_incoming
			,@conflict_type
			,@is_incoming_winner
			,@reason_code
			,@reason_text
			,NULL
			,@MSp2pPreVersion
		insert [dbo].[conflict_dbo_courses] (

			[coursecode],
			[description]			,__$originator_id
			,__$origin_datasource
			,__$tranid
			,__$conflict_type
			,__$is_winner
			,__$reason_code
			,__$reason_text
			,__$pre_version
			,__$change_id)
		select 

			[coursecode],
			[description]			,@peer_id_current_node
			,@peer_id_on_disk
			,@tranid_on_disk
			,@conflict_type
			,@is_on_disk_winner
			,@reason_code
			,@reason_text
			,NULL
			,(select change_id from #change_id)
		from [dbo].[courses] 

	where [coursecode] = @pkc1
	end 
	if(@is_incoming_winner = 1)
	begin  
	delete from [dbo].[courses] 

	where [coursecode] = @pkc1
	end  
		set @primarykey_text = @primarykey_text + '[coursecode] = ' + convert(nvarchar(100),@pkc1,1) + ', '
		if exists(select * from syspublications p join sysarticles a on a.pubid = p.pubid where a.objid = object_id(N'[dbo].[courses]') and p.options & 0x10 = 0x10)
			raiserror(22815, 10, -1, @conflict_type_txt, @peer_id_current_node, @peer_id_incoming, @tranid_incoming,  @peer_id_on_disk, @tranid_on_disk, N'[dbo].[courses]', @primarykey_text, @cur_version_text, @MSp2pPreVersion_text, @MSp2pPostVersion_text) with log
		else
			raiserror(22815, 16, -1, @conflict_type_txt, @peer_id_current_node, @peer_id_incoming, @tranid_incoming,  @peer_id_on_disk, @tranid_on_disk, N'[dbo].[courses]', @primarykey_text, @cur_version_text, @MSp2pPreVersion_text, @MSp2pPostVersion_text) with log
end 
end  
GO
