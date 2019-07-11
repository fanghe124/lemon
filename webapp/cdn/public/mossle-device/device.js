var deviceStatusObj = {
		"空闲" : "free",
		"使用" : "use",
		"报废" : "dump",
		};

var deviceStatusCnObj = {
		"free" : "空闲",
		"use" : "使用",
		"dump" : "报废",
		};

var classNameLength = 15;

var app = new Vue({
		el: '#app',
	    data: {
	    	path : "http://localhost:8080",
	    	flag  : false,
	    	classTableData: [{ className: '全部'},{ className: '种类一'},{ className: '种类二'}],
	    	deviceTableData: [],
	    	currentRow : null,
	    	dialogFormVisible : false,
	    	form: {
	            name: '',
	            number: '',
	            className : '',
	            status : '',
	          },
	          formNew: {
		            name: '',
		            number: '',
		            className : '',
		            status : '',
		          },
	          options: [{
	                value: '空闲',
	                label: '空闲'
	              }, {
	                value: '使用',
	                label: '使用'
	              }, {
	                value: '报废',
	                label: '报废'
	              }],
	          statusValue : "空闲",
	          formLabelWidth: '120px',
	          selectedClassName : "all",
	          showFlag : true,
	          currentPage : 1,
		      totalSize   : 10,
		      pageSize    : 5,
		     filterTableData : [],
		     currentDeviceId : "",
	      
	    },
	    methods: {
			handleSizeChange :function(size) {
				this.pageSize = size; 
		    },
		    handleCurrentChange : function(currentPage) {
		    	if($.trim(currentPage)){
		    		this.currentPage = currentPage;
		    	}else{
		    		this.currentPage = 1;
		    	}
		    	 
		    },
			handleCurrentRowChange : function (val) {
				if($.trim(val)){
					this.currentRow = val;
				}
		    },
		    getClassTableData : function(){
		    	this.selectedClassName = "all";
		    	var _self = this;
		    	$.ajax({
		            url: _self.path+"/lemon/device/device-class-list.do",
		            type: "POST",
		            dataType: "json",
		            async: false,
		            success: function(data) {
		            	_self.classTableData = data;
		            	if($.trim(data)){
		            		for(var i=0;i<data.length;i++){
		            			if(data[i].className == "all"){
		            				data[i].className = "全部";
		            			}
		            			if(data[i].className.length > classNameLength){
		            				data[i].classCutName = data[i].className.substring(0,classNameLength)+"...";
		            			}else{
		            				data[i].classCutName = data[i].className;
		            			}
		            		}
		            		_self.setCurrent(data[0]);
		            	}
		            	
		            },
		            error: function() {
		              alert("error");
		            }
		          });
		    	
		    },
		    getDeviceTableData : function(){
		    	var _self = this;
		    	if(_self.selectedClassName == "全部"){
		    		_self.selectedClassName ="all";
		    	}
		    	$.ajax({
		            url: _self.path+"/lemon/device/device-list.do",
		            type: "POST",
		            dataType: "json",
		            data: {
		              "selectedClassName": _self.selectedClassName,
		            },
		            async: false,
		            success: function(data) {
		            	if($.trim(data)){
		            		_self.showFlag = true;
		            		for(var i =0;i<data.length;i++){
		            			data[i].status = deviceStatusCnObj[data[i].status];
		            		}
		            	}else{
		            		_self.showFlag = false;
		            	}
		            	_self.deviceTableData = data;
		            	_self.filterTableData = data;
		            	
		            	
		            },
		            error: function() {
		              alert("error");
		            }
		          });
		    },
		    saveDeviceInfo : function (){
		    	var _self = this;
		    	this.dialogFormVisible = false;
		    	var deviceName = this.form.name;
		    	var deviceNumber = this.form.number;
		    	var deviceClass = this.form.className;
		    	var deviceStatus = deviceStatusObj[this.statusValue];
		    	$.ajax({
		            url: _self.path+"/lemon/device/device-save.do",
		            type: "POST",
		            dataType: "json",
		            data: {
		              "deviceId" : _self.currentDeviceId,
		              "deviceName": deviceName,
		              "deviceNumber": deviceNumber,
		              "deviceClass": deviceClass,
		              "deviceStatus": deviceStatus,
		            },
		            async: false,
		            success: function(data) {
		            
		            },
		            error: function() {
		              alert("error");
		            }
		          });
		    	this.getClassTableData();
				this.getDeviceTableData();
				_self.currentDeviceId = "";
				
		    },
		    setCurrent : function(row) {
		        this.$refs.singleTable.setCurrentRow(row);
		      },
		    handleDelete : function (index, row){
		    	var deviceId = row.id;
		    	var _self = this;
		    	if($.trim(deviceId)){
		    		$.ajax({
			            url: _self.path+"/lemon/device/device-delete.do",
			            type: "POST",
			            dataType: "json",
			            data: {
			              "deviceId": deviceId
			            },
			            async: false,
			            success: function(data) {
			             
					    	//后期放在ajax中
			              _self.getClassTableData();
			              _self.getDeviceTableData();
			            },
			            error: function() {
			              alert("error");
			            }
			          });
		    	}
		    },
		    handleEdit : function(index, row){
		        var _self = this;
		        _self.currentDeviceId = row.id;
		    	if($.trim(_self.currentDeviceId)){
		    		$.ajax({
			            url: _self.path+"/lemon/device/device-edit.do",
			            type: "POST",
			            dataType: "json",
			            data: {
			              "deviceId": _self.currentDeviceId
			            },
			            async: false,
			            success: function(data) {
					    	//后期放在ajax中
			              if($.trim(data)){
			            	  _self.form.name = data.name;
			            	  _self.form.number = data.number;
			            	  _self.form.className = data.deviceClass;
			            	  _self.statusValue = deviceStatusCnObj[data.status];
			              }
			              
			            	_self.dialogFormVisible = true;
			            },
			            error: function() {
			              alert("error");
			            }
			          });
		    	}
		    	
		    	
		    },
		    closeDialog : function (){
		    	this.form = Object.assign({}, this.formNew);
		    	this.statusValue = "空闲";
		    }
	  	
	    },
	    mounted: function() {
	    	var curWwwPath = window.document.location.href;
	    	 //获取主机地址之后的目录，如： uimcardprj/share/meun.jsp
	    	var pathName = window.document.location.pathname;
	    	var pos = curWwwPath.indexOf(pathName);
	    	 //获取主机地址，如： http://localhost:8083
	    	this.path = curWwwPath.substring(0, pos);
			this.getClassTableData();
			this.getDeviceTableData();
		},
		watch: {
		  currentRow:function(){
				this.$nextTick(function(){
					this.$refs.singleTable.setCurrentRow(this.currentRow);
					if($.trim(this.currentRow)){
			    		this.selectedClassName = this.currentRow.className;
			    	}else{
			    		this.selectedClassName ="all";
			    	}
//					this.deviceTableData= [{ deviceName: '2hao',deviceNum:'jjj'}];
					this.getDeviceTableData();

		        });
		  },
		  filterTableData : function(){
			   this.totalSize = this.filterTableData.length;
			   this.currentPage =1;
			   let _data = this.filterTableData.slice((this.currentPage-1)*this.pageSize,this.currentPage*this.pageSize);
			   this.deviceTableData = _data;
		   },
		   currentPage :function(){
			   let _data = this.filterTableData.slice((this.currentPage-1)*this.pageSize,this.currentPage*this.pageSize);
			   this.deviceTableData = _data;
		   },
		   pageSize : function(){
			   let _data = this.filterTableData.slice((this.currentPage-1)*this.pageSize,this.currentPage*this.pageSize);
			   this.deviceTableData = _data;
		   },
	  }
	});