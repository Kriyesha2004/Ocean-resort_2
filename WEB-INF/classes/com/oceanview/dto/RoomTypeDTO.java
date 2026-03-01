package com.oceanview.dto;

import java.io.Serializable;

/**
 * Data Transfer Object for RoomType.
 * Used to transfer room type data between layers without exposing domain models.
 */
public class RoomTypeDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private int typeId;
    private String typeName;
    private double price;
    private String description;
    private String imageUrl;
    private int capacity;

    public RoomTypeDTO() {
    }

    public RoomTypeDTO(int typeId, String typeName, double price, String description, String imageUrl, int capacity) {
        this.typeId = typeId;
        this.typeName = typeName;
        this.price = price;
        this.description = description;
        this.imageUrl = imageUrl;
        this.capacity = capacity;
    }

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }
}
