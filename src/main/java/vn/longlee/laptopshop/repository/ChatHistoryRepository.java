package vn.longlee.laptopshop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import vn.longlee.laptopshop.domain.User;
import vn.longlee.laptopshop.entity.ChatHistory;

@Repository
public interface ChatHistoryRepository extends JpaRepository<ChatHistory, Long> {
    @Query("SELECT ch FROM ChatHistory ch ORDER BY ch.timestamp DESC")
    List<ChatHistory> findAllOrderByTimestampDesc();
    
    @Query("SELECT ch FROM ChatHistory ch WHERE ch.user = :user ORDER BY ch.timestamp ASC")
    List<ChatHistory> findByUserOrderByTimestampAsc(@Param("user") User user);
    
    @Modifying
    @Transactional
    @Query("DELETE FROM ChatHistory ch WHERE ch.user = :user")
    void deleteByUser(@Param("user") User user);
} 