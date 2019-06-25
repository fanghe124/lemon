package com.mossle.model.persistence.domain;

// Generated by Hibernate Tools
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

/**
 * ModelCategory .
 * 
 * @author Lingo
 */
@Entity
@Table(name = "MODEL_CATEGORY")
public class ModelCategory implements java.io.Serializable {
    private static final long serialVersionUID = 0L;

    /** null. */
    private Long id;

    /** null. */
    private String code;

    /** null. */
    private String name;

    /** null. */
    private String description;

    /** null. */
    private String tenantId;

    /** . */
    private Set<ModelSchema> modelSchemas = new HashSet<ModelSchema>(0);

    /** . */
    private Set<ModelBase> modelBases = new HashSet<ModelBase>(0);

    public ModelCategory() {
    }

    public ModelCategory(Long id) {
        this.id = id;
    }

    public ModelCategory(Long id, String code, String name, String description,
            String tenantId, Set<ModelSchema> modelSchemas,
            Set<ModelBase> modelBases) {
        this.id = id;
        this.code = code;
        this.name = name;
        this.description = description;
        this.tenantId = tenantId;
        this.modelSchemas = modelSchemas;
        this.modelBases = modelBases;
    }

    /** @return null. */
    @Id
    @Column(name = "ID", unique = true, nullable = false)
    public Long getId() {
        return this.id;
    }

    /**
     * @param id
     *            null.
     */
    public void setId(Long id) {
        this.id = id;
    }

    /** @return null. */
    @Column(name = "CODE", length = 50)
    public String getCode() {
        return this.code;
    }

    /**
     * @param code
     *            null.
     */
    public void setCode(String code) {
        this.code = code;
    }

    /** @return null. */
    @Column(name = "NAME", length = 200)
    public String getName() {
        return this.name;
    }

    /**
     * @param name
     *            null.
     */
    public void setName(String name) {
        this.name = name;
    }

    /** @return null. */
    @Column(name = "DESCRIPTION", length = 200)
    public String getDescription() {
        return this.description;
    }

    /**
     * @param description
     *            null.
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /** @return null. */
    @Column(name = "TENANT_ID", length = 64)
    public String getTenantId() {
        return this.tenantId;
    }

    /**
     * @param tenantId
     *            null.
     */
    public void setTenantId(String tenantId) {
        this.tenantId = tenantId;
    }

    /** @return . */
    @OneToMany(fetch = FetchType.LAZY, mappedBy = "modelCategory")
    public Set<ModelSchema> getModelSchemas() {
        return this.modelSchemas;
    }

    /**
     * @param modelSchemas
     *            .
     */
    public void setModelSchemas(Set<ModelSchema> modelSchemas) {
        this.modelSchemas = modelSchemas;
    }

    /** @return . */
    @OneToMany(fetch = FetchType.LAZY, mappedBy = "modelCategory")
    public Set<ModelBase> getModelBases() {
        return this.modelBases;
    }

    /**
     * @param modelBases
     *            .
     */
    public void setModelBases(Set<ModelBase> modelBases) {
        this.modelBases = modelBases;
    }
}
