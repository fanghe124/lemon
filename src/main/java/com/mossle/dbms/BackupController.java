package com.mossle.dbms;

import com.mossle.api.tenant.TenantHolder;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;

import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("dbms")
public class BackupController {
	
	private boolean enabled = false;

	/**
     * 登陆用户名.
     */
    private String username;

    /**
     * 登陆密码.
     */
    private String password;
    private String databaseName;

	private static Logger logger = LoggerFactory
		.getLogger(RestoreController.class);
	
    @RequestMapping("backup-home")
    public String list() {
    	
    	return "dbms/backup-home";
	}
    
    @RequestMapping("backup-db")
    public String backup(Model model) {
    	if(enabled) {
    		String executeCmd = "mysqldump -u " + username + " -p" + password + " -B " + databaseName + " -r " + databaseName + ".sql";
    		Process runtimeProcess;
    		 
    		try {
    		    runtimeProcess = Runtime.getRuntime().exec(executeCmd);
    		    int processComplete = runtimeProcess.waitFor();
    		    if (processComplete == 0) {
    		    	model.addAttribute("BackupState", true);
    		    	logger.info("Backup created successfully");
    		    } else {
    		    	model.addAttribute("BackupState", false);
    		    	logger.info("Could not create the backup");
    		    }
    		} catch (Exception ex) {
    		    ex.printStackTrace();
    		}
    	}
    	  
    	return "dbms/backup-home";
	}

    // ~ ======================================================================
	
	public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setDatabaseName(String databaseName) {
        this.databaseName = databaseName;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }
}
