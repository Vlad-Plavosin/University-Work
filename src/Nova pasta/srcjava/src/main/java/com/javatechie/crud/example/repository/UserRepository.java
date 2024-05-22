package com.javatechie.crud.example.repository;

import com.javatechie.crud.example.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User,Integer> {
}

