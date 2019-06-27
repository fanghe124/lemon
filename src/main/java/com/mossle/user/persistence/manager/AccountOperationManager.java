package com.mossle.user.persistence.manager;

import com.mossle.core.hibernate.HibernateEntityDao;
import com.mossle.user.persistence.domain.AccountDevice;
import com.mossle.user.persistence.domain.AccountOperation;

import org.springframework.stereotype.Service;

@Service
public class AccountOperationManager extends HibernateEntityDao<AccountOperation> {
}
