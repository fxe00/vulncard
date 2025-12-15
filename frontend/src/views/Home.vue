<template>
  <div class="home-container">
    <el-container>
      <el-header>
        <h1><i class="fas fa-shield-alt"></i> 漏洞卡片管理系统</h1>
      </el-header>
      <el-main>
        <el-card>
          <template #header>
            <div class="card-header">
              <span>漏洞卡片列表</span>
              <el-button type="primary" @click="loadCards">
                <el-icon><Refresh /></el-icon> 刷新
              </el-button>
            </div>
          </template>
          <el-loading v-loading="loading" />
          <el-empty v-if="!loading && cards.length === 0" description="暂无漏洞卡片" />
          <el-row :gutter="20" v-else>
            <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="card in cards" :key="card.id">
              <el-card class="vuln-card-item" @click="goToCard(card.id)" shadow="hover">
                <div class="card-icon">
                  <i class="fas fa-bug"></i>
                </div>
                <h3>{{ card.name }}</h3>
                <el-button type="primary" link @click.stop="goToCard(card.id)">
                  查看详情 <el-icon><ArrowRight /></el-icon>
                </el-button>
              </el-card>
            </el-col>
          </el-row>
        </el-card>
      </el-main>
    </el-container>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'
import { ElMessage } from 'element-plus'
import { Refresh, ArrowRight } from '@element-plus/icons-vue'

export default {
  name: 'Home',
  components: {
    Refresh,
    ArrowRight
  },
  setup() {
    const router = useRouter()
    const cards = ref([])
    const loading = ref(false)

    const loadCards = async () => {
      loading.value = true
      try {
        const response = await axios.get('/api/vulnerabilities')
        cards.value = response.data.cards || []
      } catch (error) {
        console.error('加载卡片失败:', error)
        ElMessage.error('加载卡片失败')
      } finally {
        loading.value = false
      }
    }

    const goToCard = (id) => {
      router.push(`/card/${id}`)
    }

    onMounted(() => {
      loadCards()
    })

    return {
      cards,
      loading,
      loadCards,
      goToCard
    }
  }
}
</script>

<style scoped>
.home-container {
  min-height: 100vh;
  padding: 20px;
}

.el-header {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.el-header h1 {
  font-size: 28px;
  font-weight: 600;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.vuln-card-item {
  margin-bottom: 20px;
  cursor: pointer;
  transition: transform 0.3s;
}

.vuln-card-item:hover {
  transform: translateY(-5px);
}

.card-icon {
  text-align: center;
  font-size: 48px;
  color: #e74c3c;
  margin-bottom: 15px;
}

.vuln-card-item h3 {
  text-align: center;
  margin-bottom: 15px;
  color: #2c3e50;
}
</style>

