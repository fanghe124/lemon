package com.mossle.disk.api;

import java.io.InputStream;
import java.io.PrintWriter;

import javax.annotation.Resource;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mossle.api.auth.CurrentUserHolder;
import com.mossle.api.tenant.TenantHolder;

import com.mossle.client.store.StoreClient;
import com.mossle.core.util.IoUtils;
import com.mossle.core.util.ServletUtils;
import com.mossle.disk.persistence.domain.DiskInfo;
import com.mossle.disk.persistence.manager.DiskInfoManager;
import com.mossle.disk.service.DiskService;

import org.apache.commons.io.IOUtils;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("disk/api")
public class DiskApiController {
	private DiskInfoManager diskInfoManager;
	private StoreClient storeClient;
	private TenantHolder tenantHolder;
	private CurrentUserHolder currentUserHolder;
	private DiskService diskService;
	
	@RequestMapping(value = "{username}")
	public void diskstore(@RequestParam("id") Long id,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String userId = currentUserHolder.getUserId();
        String tenantId = tenantHolder.getTenantId();
        DiskInfo diskInfo = diskInfoManager.get(id);
        InputStream is = null;

        try {
            
            is = storeClient
                    .getStore("disk/user/" + userId, diskInfo.getRef(),
                            tenantId).getDataSource().getInputStream();
            
            /*
            response.setContentType( "text/plain;charset=UTF-8" );
            response.setHeader( "Content-Disposition", "attachment;filename=MyTextFile.txt" );
            PrintWriter out = response.getWriter();

            try {

                out.println( "Some content..." );
                out.println( "Some more..." );

            } finally {            
                out.close();
            }
            */
            
            //response.setContentType("image/png");

            //if(diskInfo.getType() == "txt")
            //String text = IOUtils.toString(is, "utf-8");
            
            //response.setContentType("text/html;charset=UTF-8");
            //IoUtils.copyStream(is, response.getOutputStream());
            IOUtils.copy(is, response.getOutputStream());
        } finally {
            if (is != null) {
                is.close();
            }
        }
    }
	
	/*public void diskStore(
			@PathVariable("id") String username,
			@RequestParam(value = "width", required = false, defaultValue = "16") int width,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String tenantId = tenantHolder.getTenantId();

		InputStream is = userAvatarService.viewAvatarByUsername(username,
				width, tenantId).getInputStream();

		response.setContentType("image/png");
		IOUtils.copy(is, response.getOutputStream());
	}*/

	// ~ ======================================================================
	// ~ ======================================================================
    @Resource
    public void setDiskInfoManager(DiskInfoManager diskInfoManager) {
        this.diskInfoManager = diskInfoManager;
    }

    
    @Resource
    public void setCurrentUserHolder(CurrentUserHolder currentUserHolder) {
        this.currentUserHolder = currentUserHolder;
    }

    @Resource
    public void setStoreClient(StoreClient storeClient) {
        this.storeClient = storeClient;
    }

    @Resource
    public void setDiskService(DiskService diskService) {
        this.diskService = diskService;
    }

    @Resource
    public void setTenantHolder(TenantHolder tenantHolder) {
        this.tenantHolder = tenantHolder;
    }
}
