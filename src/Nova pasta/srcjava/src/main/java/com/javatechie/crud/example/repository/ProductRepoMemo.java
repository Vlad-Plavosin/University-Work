package com.javatechie.crud.example.repository;

import com.github.javafaker.Faker;
import com.javatechie.crud.example.entity.Product;

import java.util.ArrayList;

public class ProductRepoMemo {
    public ArrayList<Product> products = new ArrayList<Product>();
    Faker faker = new Faker();
    public ProductRepoMemo(){
//        products.add(new Product(1,"round",faker.company().name(),faker.color().name(),1,1));
//        products.add(new Product(2,"square",faker.company().name(),faker.color().name(),1,1));
//        products.add(new Product(3,"sharp",faker.company().name(),faker.color().name(),1,1));
//        products.add(new Product(4,"diamond",faker.company().name(),faker.color().name(),1,1));
//        products.add(new Product(5,"star",faker.company().name(),faker.color().name(),1,1));
    }


}
