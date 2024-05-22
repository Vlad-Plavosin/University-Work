package com.javatechie.crud.example.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "PRODUCT")
public class Product {

    @Id
    @GeneratedValue
    private int id;
    private String shape;
    private String supplier;
    private String color;
    private int count;
    private int quality;
    private int userId;

    public Product(String shape, String supplier, String color, int count, int quality,int userId) {
        this.shape = shape;
        this.supplier = supplier;
        this.color = color;
        this.count = count;
        this.quality = quality;
        this.userId = userId;
    }
}
